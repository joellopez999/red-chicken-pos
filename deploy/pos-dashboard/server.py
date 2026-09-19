#!/usr/bin/env python3
"""Panel local de control/estado para Red Chicken POS. Solo stdlib, sin dependencias.

Escucha en 127.0.0.1 (no expuesto a la red) y expone:
  GET  /                     -> dashboard HTML
  GET  /api/status            -> JSON con estado de contenedores, tailscale, disco, negocio
                                  y la lectura actual de CPU/RAM/energía (metrics)
  GET  /api/metrics/history   -> historial de CPU/RAM/energía por rango (?range=1h|6h|24h|7d)
  POST /api/action            -> {"action": "start"|"stop"|"restart"} sobre el stack docker compose
"""

import json
import re
import shutil
import sqlite3
import subprocess
import threading
import time
import urllib.parse
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

REPO_DIR = "/home/imac/red-chicken-pos"
COMPOSE_BASE = [
    "docker", "compose",
    "-f", "docker-compose.yml",
    "-f", "docker-compose.dev.yml",
    "-f", "docker-compose.front-prod.yml",  # real compiled frontend build, not `ng serve`
    "--env-file", "config.env",
]
FRONTEND_PORT = 8080
DASHBOARD_PORT = 8090
STATIC_DIR = Path(__file__).parent
SERVICES = ["back", "front", "db", "redis", "ws-bridge", "haproxy"]


def run(cmd, timeout=20, cwd=None):
    try:
        p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout)
        return p.returncode, p.stdout, p.stderr
    except Exception as exc:  # noqa: BLE001 - surfaced to dashboard, not fatal
        return -1, "", str(exc)


def get_containers():
    rc, out, err = run(COMPOSE_BASE + ["ps", "--format", "json", "-a"], cwd=REPO_DIR)
    containers = []
    if rc == 0:
        for line in out.splitlines():
            line = line.strip()
            if not line:
                continue
            try:
                containers.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    stats_by_name = {}
    names = [c["Name"] for c in containers if c.get("State") == "running"]
    if names:
        rc2, out2, _ = run(["docker", "stats", "--no-stream", "--format", "{{json .}}"] + names, timeout=10)
        if rc2 == 0:
            for line in out2.splitlines():
                line = line.strip()
                if not line:
                    continue
                try:
                    s = json.loads(line)
                    stats_by_name[s["Name"]] = s
                except json.JSONDecodeError:
                    continue
    result = []
    for c in containers:
        name = c.get("Name", "")
        s = stats_by_name.get(name, {})
        result.append({
            "service": c.get("Service", ""),
            "name": name,
            "state": c.get("State", "unknown"),
            "status": c.get("Status", ""),
            "health": c.get("Health", ""),
            "cpu": s.get("CPUPerc", "-"),
            "mem": s.get("MemUsage", "-"),
            "mem_percent": s.get("MemPerc", "-"),
        })
    result.sort(key=lambda r: SERVICES.index(r["service"]) if r["service"] in SERVICES else 99)
    return result


def get_tailscale():
    info = {"connected": False, "ip": None, "hostname": None, "funnel_active": False, "public_url": None}
    rc, out, _ = run(["tailscale", "status", "--json"], timeout=8)
    if rc == 0:
        try:
            data = json.loads(out)
            info["connected"] = data.get("BackendState") == "Running"
            ips = data.get("TailscaleIPs") or []
            info["ip"] = ips[0] if ips else None
            info["hostname"] = (data.get("Self") or {}).get("DNSName", "").rstrip(".")
        except json.JSONDecodeError:
            pass
    rc2, out2, _ = run(["tailscale", "funnel", "status", "--json"], timeout=8)
    if rc2 == 0:
        try:
            data = json.loads(out2)
            web = data.get("Web") or {}
            if web:
                host = next(iter(web.keys())).split(":")[0]
                info["funnel_active"] = True
                info["public_url"] = f"https://{host}/"
        except json.JSONDecodeError:
            pass
    return info


def get_disk():
    total, used, free = shutil.disk_usage("/")
    gb = 1024 ** 3
    disk = {
        "host_total_gb": round(total / gb, 1),
        "host_used_gb": round(used / gb, 1),
        "host_free_gb": round(free / gb, 1),
        "host_used_percent": round(used / total * 100, 1),
        "pg_volume_size": None,
    }
    rc, out, _ = run(["docker", "exec", "pos-postgres", "du", "-sh", "/var/lib/postgresql"], timeout=10)
    if rc == 0 and out.strip():
        disk["pg_volume_size"] = out.split()[0]
    return disk


def get_business():
    biz = {"orders_today": None, "open_orders": None, "revenue_today": None, "error": None}
    sql = (
        'SELECT '
        '(SELECT count(*) FROM "order" WHERE created_at::date = current_date AND deleted_at IS NULL), '
        "(SELECT count(*) FROM \"order\" WHERE status NOT IN ('paid','completed','cancelled') AND deleted_at IS NULL), "
        '(SELECT COALESCE(SUM(oi.quantity * oi.price_cents + COALESCE(oi.tax_amount_cents,0)),0) '
        ' FROM orderitem oi JOIN "order" o ON o.id = oi.order_id '
        ' WHERE o.paid_at::date = current_date AND o.deleted_at IS NULL);'
    )
    rc, out, err = run(
        ["docker", "exec", "pos-postgres", "psql", "-U", "pos", "-d", "pos", "-t", "-A", "-F", "|", "-c", sql],
        timeout=10,
    )
    if rc == 0 and out.strip():
        parts = out.strip().split("|")
        if len(parts) == 3:
            biz["orders_today"] = int(parts[0])
            biz["open_orders"] = int(parts[1])
            biz["revenue_today"] = round(int(parts[2]) / 100, 2)
    else:
        biz["error"] = "db_unreachable"
    return biz


TENANT_TZ = "America/Guayaquil"
_DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
_ACTION_TYPE_RE = re.compile(r"^[a-z0-9_]+$")


def _psql_json(sql, timeout=10):
    """Run a query on pos-postgres and parse its single-row `-t -A` output as JSON."""
    rc, out, err = run(
        ["docker", "exec", "pos-postgres", "psql", "-U", "pos", "-d", "pos", "-t", "-A", "-c", sql],
        timeout=timeout,
    )
    if rc != 0:
        return None, err.strip() or "query_failed"
    try:
        return json.loads(out.strip() or "null"), None
    except json.JSONDecodeError:
        return None, "bad_json"


def get_staff_log(params):
    """Filtered view of staff_action_log for the panel, built server-side as JSON
    (avoids fragile delimiter-splitting of free-text summary/error columns)."""
    from_date = params.get("from", [""])[0]
    to_date = params.get("to", [""])[0]
    action_type = params.get("action_type", [""])[0]
    only_errors = params.get("only_errors", [""])[0] == "true"

    where = []
    if _DATE_RE.match(from_date):
        where.append(f"(created_at AT TIME ZONE '{TENANT_TZ}') >= '{from_date}'::date")
    if _DATE_RE.match(to_date):
        where.append(f"(created_at AT TIME ZONE '{TENANT_TZ}') < ('{to_date}'::date + interval '1 day')")
    if action_type and _ACTION_TYPE_RE.match(action_type):
        where.append(f"action_type = '{action_type}'")
    if only_errors:
        where.append("success = false")
    where_sql = f"WHERE {' AND '.join(where)}" if where else ""

    sql = (
        "SELECT COALESCE(json_agg(row_to_json(t) ORDER BY t.created_at DESC), '[]'::json) FROM ("
        f"  SELECT id, created_at, user_email, action_type, summary, success, error_message, request_path"
        f"  FROM staff_action_log {where_sql}"
        "  ORDER BY created_at DESC LIMIT 200"
        ") t;"
    )
    entries, err = _psql_json(sql)
    if entries is None:
        return {"entries": [], "action_types": [], "error": err}

    types, _ = _psql_json("SELECT COALESCE(json_agg(DISTINCT action_type), '[]'::json) FROM staff_action_log;")
    return {"entries": entries, "action_types": sorted(types or []), "error": None}


_PRODUCT_ID_RE = re.compile(r"^\d+$")

# Same revenue-counting rules as the app's own reports engine (back/app/reports_routes.py):
# only paid/completed orders, excluding removed/cancelled items; date = paid_at (fallback
# created_at), converted from UTC to the tenant's local calendar day before filtering.
_REVENUE_ITEMS_CTE = f"""
WITH items AS (
    SELECT
        oi.product_id,
        oi.product_name,
        oi.quantity,
        (oi.quantity * oi.price_cents + COALESCE(oi.tax_amount_cents, 0)) AS revenue_cents,
        o.id AS order_id,
        (COALESCE(o.paid_at, o.created_at) AT TIME ZONE '{TENANT_TZ}')::date AS rev_date
    FROM orderitem oi
    JOIN "order" o ON o.id = oi.order_id
    WHERE o.deleted_at IS NULL
      AND o.status IN ('paid', 'completed')
      AND oi.removed_by_customer = false
      AND oi.status != 'cancelled'
)
"""


def get_business_stats(params):
    """Filtered business stats (date range + product) for the panel — the always-on
    'Negocio (hoy)' card stays fixed to today via get_business(); this is the drill-down."""
    from_date = params.get("from", [""])[0]
    to_date = params.get("to", [""])[0]
    product_id = params.get("product_id", [""])[0]

    where = []
    if _DATE_RE.match(from_date):
        where.append(f"rev_date >= '{from_date}'::date")
    if _DATE_RE.match(to_date):
        where.append(f"rev_date <= '{to_date}'::date")
    if product_id and _PRODUCT_ID_RE.match(product_id):
        where.append(f"product_id = {int(product_id)}")
    where_sql = f"WHERE {' AND '.join(where)}" if where else ""

    summary_sql = (
        _REVENUE_ITEMS_CTE
        + "SELECT COALESCE(json_build_object("
        + "  'revenue_cents', COALESCE(SUM(revenue_cents), 0),"
        + "  'order_count', COUNT(DISTINCT order_id),"
        + "  'quantity', COALESCE(SUM(quantity), 0)"
        + "), '{}'::json) FROM items " + where_sql + ";"
    )
    summary, err = _psql_json(summary_sql)
    if summary is None:
        return {"summary": None, "by_product": [], "products": [], "error": err}

    by_product_sql = (
        _REVENUE_ITEMS_CTE
        + "SELECT COALESCE(json_agg(row_to_json(t) ORDER BY t.revenue_cents DESC), '[]'::json) FROM ("
        + "  SELECT product_id, product_name, SUM(quantity) AS quantity, SUM(revenue_cents) AS revenue_cents"
        + "  FROM items " + where_sql
        + "  GROUP BY product_id, product_name"
        + ") t;"
    )
    by_product, _ = _psql_json(by_product_sql)

    products, _ = _psql_json(
        _REVENUE_ITEMS_CTE
        + "SELECT COALESCE(json_agg(row_to_json(t) ORDER BY t.product_name), '[]'::json) FROM ("
        + "  SELECT DISTINCT product_id, product_name FROM items"
        + ") t;"
    )

    return {
        "summary": summary,
        "by_product": by_product or [],
        "products": products or [],
        "error": None,
    }


# ---------- System resource metrics (CPU / RAM / power) ----------
# Stdlib-only: reads /proc directly instead of adding a psutil dependency, consistent
# with this panel's "no external deps" design (it must keep working even with no
# internet — e.g. exactly when you'd most want to check the machine's health).

METRICS_DB_PATH = Path(__file__).parent / "metrics.db"
RAPL_ENERGY_PATH = Path("/sys/class/powercap/intel-rapl:0/energy_uj")
RAPL_MAX_RANGE_PATH = Path("/sys/class/powercap/intel-rapl:0/max_energy_range_uj")
SAMPLE_INTERVAL_SECONDS = 60
METRICS_RETENTION_DAYS = 30

_rapl_max_range_uj = None
if RAPL_MAX_RANGE_PATH.is_file():
    try:
        _rapl_max_range_uj = int(RAPL_MAX_RANGE_PATH.read_text().strip())
    except (OSError, ValueError):
        pass


def read_cpu_jiffies():
    """Total and idle jiffies from the aggregate 'cpu' line of /proc/stat."""
    try:
        with open("/proc/stat") as f:
            parts = f.readline().split()
        values = [int(v) for v in parts[1:]]
        idle = values[3] + (values[4] if len(values) > 4 else 0)  # idle + iowait
        return sum(values), idle
    except (OSError, ValueError, IndexError):
        return None, None


def read_meminfo_kb():
    """(total_kb, available_kb) from /proc/meminfo."""
    total = avail = None
    try:
        with open("/proc/meminfo") as f:
            for line in f:
                if line.startswith("MemTotal:"):
                    total = int(line.split()[1])
                elif line.startswith("MemAvailable:"):
                    avail = int(line.split()[1])
                if total is not None and avail is not None:
                    break
    except (OSError, ValueError, IndexError):
        pass
    return total, avail


def read_rapl_energy_uj():
    """CPU package energy counter in microjoules, or None if unreadable (permissions
    not yet set up, or non-Intel/no-RAPL hardware)."""
    try:
        return int(RAPL_ENERGY_PATH.read_text().strip())
    except (OSError, ValueError):
        return None


_last_reading = {"t": None, "cpu_total": None, "cpu_idle": None, "energy_uj": None}
_last_reading_lock = threading.Lock()


def take_reading():
    """Instantaneous host CPU%/RAM%/power reading, computed as a delta since the
    previous call (from any caller — the live status poll and the history sampler
    share this same state). Thread-safe; never raises."""
    global _last_reading
    with _last_reading_lock:
        now = time.time()
        cpu_total, cpu_idle = read_cpu_jiffies()
        mem_total_kb, mem_avail_kb = read_meminfo_kb()
        energy_uj = read_rapl_energy_uj()
        prev = _last_reading

        cpu_percent = None
        power_watts = None
        if prev["t"] is not None and (now - prev["t"]) > 0.5:
            if cpu_total is not None and prev["cpu_total"] is not None:
                d_total = cpu_total - prev["cpu_total"]
                d_idle = cpu_idle - prev["cpu_idle"]
                if d_total > 0:
                    cpu_percent = round(max(0.0, min(100.0, (1 - d_idle / d_total) * 100)), 1)
            if energy_uj is not None and prev["energy_uj"] is not None:
                delta_uj = energy_uj - prev["energy_uj"]
                if delta_uj < 0 and _rapl_max_range_uj:  # counter wrapped
                    delta_uj += _rapl_max_range_uj
                dt = now - prev["t"]
                if delta_uj >= 0 and dt > 0:
                    power_watts = round((delta_uj / 1_000_000) / dt, 1)

        mem_percent = None
        mem_used_mb = None
        mem_total_mb = None
        if mem_total_kb:
            mem_total_mb = round(mem_total_kb / 1024)
            if mem_avail_kb is not None:
                mem_used_mb = round((mem_total_kb - mem_avail_kb) / 1024)
                mem_percent = round((mem_total_kb - mem_avail_kb) / mem_total_kb * 100, 1)

        _last_reading = {"t": now, "cpu_total": cpu_total, "cpu_idle": cpu_idle, "energy_uj": energy_uj}
        return {
            "ts": now,
            "cpu_percent": cpu_percent,
            "mem_percent": mem_percent,
            "mem_used_mb": mem_used_mb,
            "mem_total_mb": mem_total_mb,
            "power_watts": power_watts,
            # Reflects whether the RAPL counter is actually readable right now (permissions
            # set up via the udev rule), not just whether the sysfs path exists.
            "power_available": energy_uj is not None,
            "screen_idle": is_display_idle(),
        }


def get_active_graphical_session_id():
    """The seat0 graphical session (Wayland/X11) — not the systemd --user 'manager' session
    that also shows up in `loginctl list-sessions` for this same user."""
    rc, out, _ = run(["loginctl", "list-sessions", "--no-legend"])
    if rc != 0:
        return None
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 4 and parts[3] == "seat0":
            return parts[0]
    return None


def is_display_idle():
    """True once GNOME's own idle-delay (currently 900s — see gsettings
    org.gnome.desktop.session idle-delay) has blanked the screen. Read via systemd-logind's
    IdleHint rather than anything GNOME-specific, so it keeps working if the desktop
    environment ever changes. Best-effort: assumes screen ON (False) if undetermined —
    that's the conservative direction for a cost estimate (doesn't overstate savings)."""
    sid = get_active_graphical_session_id()
    if not sid:
        return False
    rc, out, _ = run(["loginctl", "show-session", sid, "-p", "IdleHint"])
    return rc == 0 and out.strip() == "IdleHint=yes"


def _metrics_db():
    conn = sqlite3.connect(METRICS_DB_PATH)
    conn.execute(
        "CREATE TABLE IF NOT EXISTS metrics ("
        " ts INTEGER PRIMARY KEY,"
        " cpu_percent REAL,"
        " mem_percent REAL,"
        " power_watts REAL,"
        " screen_idle INTEGER"
        ")"
    )
    existing_cols = {row[1] for row in conn.execute("PRAGMA table_info(metrics)")}
    if "screen_idle" not in existing_cols:
        conn.execute("ALTER TABLE metrics ADD COLUMN screen_idle INTEGER")
    return conn


def store_reading(reading):
    if reading["cpu_percent"] is None and reading["mem_percent"] is None:
        return  # nothing usable yet (first sample right after startup)
    try:
        conn = _metrics_db()
        with conn:
            conn.execute(
                "INSERT OR REPLACE INTO metrics (ts, cpu_percent, mem_percent, power_watts, screen_idle) "
                "VALUES (?, ?, ?, ?, ?)",
                (
                    int(reading["ts"]), reading["cpu_percent"], reading["mem_percent"],
                    reading["power_watts"], int(bool(reading.get("screen_idle"))),
                ),
            )
            cutoff = int(time.time()) - METRICS_RETENTION_DAYS * 86400
            conn.execute("DELETE FROM metrics WHERE ts < ?", (cutoff,))
        conn.close()
    except sqlite3.Error:
        pass  # a lost history sample must never take down the sampler thread


_RANGE_BUCKETS = {
    "1h": (3600, 60),
    "6h": (6 * 3600, 300),
    "24h": (24 * 3600, 900),
    "7d": (7 * 24 * 3600, 7200),
}

# Tarifa eléctrica residencial promedio en Ecuador para 2026, según ARCONEL (subsidiada;
# el costo real de provisión ronda $0.1061/kWh, pero el usuario residencial paga en
# promedio esto). Variable a propósito: si ARCONEL ajusta la tarifa, se actualiza solo
# aquí y el estimado de costo en todo el panel se recalcula solo.
# Fuente: https://www.eluniverso.com/noticias/economia/tarifa-electrica-ecuador-2026-arconel-servicio-basico-nota/
ELECTRICITY_PRICE_USD_PER_KWH = 0.10

# Fórmula del estimado (para que quede visible/documentada, no escondida en el cálculo):
#   kWh/día = (potencia_promedio_W / 1000) * 24
#   costo_día = kWh/día * ELECTRICITY_PRICE_USD_PER_KWH
#   costo_mes = costo_día * 30 ; costo_año = costo_día * 365
ENERGY_COST_FORMULA = (
    "kWh/día = (W promedio ÷ 1000) × 24h  ·  "
    "costo = kWh/día × tarifa ($/kWh)  ·  mes = día×30, año = día×365"
)


# Consumo TOTAL real medido para este modelo exacto (iMac 21.5", Late 2015, i5 1.6GHz
# dual-core = iMac16,1) — RAPL no puede medir esto, así que se usa como referencia fija
# de fábrica para estimar lo que gasta "todo lo demás" (pantalla, disco, placa, fuente).
# Fuente: https://www.tpcdb.com/product.php?id=2525
IMAC_MODEL_LABEL = "iMac 21.5\" Late 2015, i5 1.6GHz (iMac16,1)"
IMAC_IDLE_TOTAL_WATTS = 33
IMAC_MAX_TOTAL_WATTS = 58
IMAC_AVG_TOTAL_WATTS = (IMAC_IDLE_TOTAL_WATTS + IMAC_MAX_TOTAL_WATTS) / 2  # 45.5 W de referencia

# GNOME apaga la pantalla tras 900s de inactividad (org.gnome.desktop.session idle-delay) —
# confirmado en este equipo, y esperable que pase la mayor parte del tiempo así, ya que
# nadie usa la pantalla física de un servidor. La referencia de fábrica (33W/58W) asume
# pantalla encendida, así que sin este ajuste el estimado total queda sobrestimado durante
# esos períodos. No es un valor medido — es una asunción típica para un panel LED de 21.5":
# corregir aquí si se consigue una cifra real para este modelo.
SCREEN_OFF_SAVINGS_WATTS = 15

TOTAL_ESTIMATE_FORMULA = (
    f"base_no_cpu = referencia_fábrica_promedio ({IMAC_AVG_TOTAL_WATTS}W) − CPU_promedio_medido  ·  "
    f"base_ajustada = base_no_cpu − (fracción_tiempo_pantalla_apagada × {SCREEN_OFF_SAVINGS_WATTS}W)  ·  "
    "total_estimado = base_ajustada + CPU_medido_ahora"
)


def estimate_total_machine_watts(avg_cpu_watts, screen_idle_fraction, live_cpu_watts):
    """Approximate whole-machine power by anchoring the part RAPL can't see (screen,
    disk, board, PSU losses) to this exact iMac model's published idle/max wattage,
    discounted for however much of the period the screen was actually blanked, then
    adding back the live CPU reading so the total still moves with real load.
    Not a real measurement — a smart plug between the iMac and the wall is the only
    way to get the true total."""
    if avg_cpu_watts is None or live_cpu_watts is None:
        return None
    non_cpu_baseline = max(0.0, IMAC_AVG_TOTAL_WATTS - avg_cpu_watts)
    screen_off_discount = (screen_idle_fraction or 0.0) * SCREEN_OFF_SAVINGS_WATTS
    adjusted_baseline = max(0.0, non_cpu_baseline - screen_off_discount)
    return round(adjusted_baseline + live_cpu_watts, 1)


def estimate_energy_cost(avg_watts, label="cpu"):
    """USD/día,mes,año for a given average power draw, at ELECTRICITY_PRICE_USD_PER_KWH."""
    if avg_watts is None:
        return None
    kwh_per_day = (avg_watts / 1000) * 24
    cost_day = kwh_per_day * ELECTRICITY_PRICE_USD_PER_KWH
    return {
        "label": label,
        "avg_watts": round(avg_watts, 1),
        "kwh_per_day": round(kwh_per_day, 3),
        "cost_usd_day": round(cost_day, 3),
        "cost_usd_month": round(cost_day * 30, 2),
        "cost_usd_year": round(cost_day * 365, 2),
        "price_usd_per_kwh": ELECTRICITY_PRICE_USD_PER_KWH,
        "formula": ENERGY_COST_FORMULA,
    }


def get_metrics_history(params):
    range_key = params.get("range", ["6h"])[0]
    window_seconds, bucket_seconds = _RANGE_BUCKETS.get(range_key, _RANGE_BUCKETS["6h"])
    since = int(time.time()) - window_seconds
    try:
        conn = _metrics_db()
        cur = conn.execute(
            "SELECT (ts / ?) * ? AS bucket, AVG(cpu_percent), AVG(mem_percent), AVG(power_watts) "
            "FROM metrics WHERE ts >= ? GROUP BY bucket ORDER BY bucket",
            (bucket_seconds, bucket_seconds, since),
        )
        rows = cur.fetchall()
        avg_power_row = conn.execute(
            "SELECT AVG(power_watts) FROM metrics WHERE ts >= ? AND power_watts IS NOT NULL", (since,)
        ).fetchone()
        screen_idle_row = conn.execute(
            "SELECT AVG(screen_idle) FROM metrics WHERE ts >= ? AND screen_idle IS NOT NULL", (since,)
        ).fetchone()
        # Most recent single sample — a proxy for "right now" without calling take_reading()
        # again here, which would fight with the sampler thread and the live status poll
        # over the shared _last_reading delta state.
        last_power_row = conn.execute(
            "SELECT power_watts FROM metrics WHERE power_watts IS NOT NULL ORDER BY ts DESC LIMIT 1"
        ).fetchone()
        conn.close()
    except sqlite3.Error:
        rows = []
        avg_power_row = (None,)
        screen_idle_row = (None,)
        last_power_row = (None,)
    avg_cpu_watts = avg_power_row[0]
    screen_idle_fraction = screen_idle_row[0] if screen_idle_row else None
    live_cpu_watts = last_power_row[0] if last_power_row else None
    return {
        "range": range_key,
        "power_available": read_rapl_energy_uj() is not None,
        "cost_estimate": estimate_energy_cost(avg_cpu_watts, label="cpu"),
        "total_estimate": {
            "model": IMAC_MODEL_LABEL,
            "idle_watts_reference": IMAC_IDLE_TOTAL_WATTS,
            "max_watts_reference": IMAC_MAX_TOTAL_WATTS,
            "screen_off_percent": round((screen_idle_fraction or 0.0) * 100, 1),
            "formula": TOTAL_ESTIMATE_FORMULA,
            "cost": estimate_energy_cost(
                estimate_total_machine_watts(avg_cpu_watts, screen_idle_fraction, live_cpu_watts or avg_cpu_watts),
                label="total_estimado",
            ),
        } if avg_cpu_watts is not None else None,
        "points": [
            {
                "ts": r[0],
                "cpu_percent": round(r[1], 1) if r[1] is not None else None,
                "mem_percent": round(r[2], 1) if r[2] is not None else None,
                "power_watts": round(r[3], 1) if r[3] is not None else None,
            }
            for r in rows
        ],
    }


def start_metrics_sampler():
    take_reading()  # prime _last_reading so the first stored sample already has a delta

    def loop():
        while True:
            time.sleep(SAMPLE_INTERVAL_SECONDS)
            try:
                store_reading(take_reading())
            except Exception:
                pass  # never let a sampling hiccup kill the background thread

    threading.Thread(target=loop, daemon=True).start()


def http_reachable(url, timeout=1.5):
    try:
        with urllib.request.urlopen(url, timeout=timeout) as r:
            return 200 <= r.status < 400
    except Exception:
        return False


def build_status():
    containers = get_containers()
    running = {c["service"] for c in containers if c["state"] == "running"}
    overall_running = "front" in running and "back" in running
    return {
        "overall_running": overall_running,
        "app_reachable": http_reachable(f"http://127.0.0.1:{FRONTEND_PORT}/") if overall_running else False,
        "containers": containers,
        "tailscale": get_tailscale(),
        "disk": get_disk(),
        "business": get_business() if "db" in running else {"error": "db_down"},
        "frontend_port": FRONTEND_PORT,
        "metrics": take_reading(),
    }


def do_action(action):
    if action == "start":
        cmd = COMPOSE_BASE + ["up", "-d"]
    elif action == "stop":
        cmd = COMPOSE_BASE + ["stop"]
    elif action == "restart":
        cmd = COMPOSE_BASE + ["restart"]
    else:
        return {"ok": False, "error": "unknown action"}
    rc, out, err = run(cmd, timeout=120, cwd=REPO_DIR)
    return {"ok": rc == 0, "output": (out + err)[-4000:]}


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # keep stdout quiet; journald/nohup log captures start/stop lines separately

    def _send_json(self, payload, status=200):
        body = json.dumps(payload).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/" or self.path == "/index.html":
            html_path = STATIC_DIR / "index.html"
            body = html_path.read_bytes()
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        elif self.path == "/api/status":
            self._send_json(build_status())
        elif self.path.startswith("/api/staff-log"):
            parsed = urllib.parse.urlsplit(self.path)
            params = urllib.parse.parse_qs(parsed.query)
            self._send_json(get_staff_log(params))
        elif self.path.startswith("/api/business-stats"):
            parsed = urllib.parse.urlsplit(self.path)
            params = urllib.parse.parse_qs(parsed.query)
            self._send_json(get_business_stats(params))
        elif self.path.startswith("/api/metrics/history"):
            parsed = urllib.parse.urlsplit(self.path)
            params = urllib.parse.parse_qs(parsed.query)
            self._send_json(get_metrics_history(params))
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        if self.path == "/api/action":
            length = int(self.headers.get("Content-Length", 0))
            raw = self.rfile.read(length) if length else b"{}"
            try:
                payload = json.loads(raw)
            except json.JSONDecodeError:
                payload = {}
            result = do_action(payload.get("action", ""))
            self._send_json(result, 200 if result.get("ok") else 500)
        else:
            self.send_response(404)
            self.end_headers()


def main():
    start_metrics_sampler()
    server = ThreadingHTTPServer(("127.0.0.1", DASHBOARD_PORT), Handler)
    print(f"Panel Red Chicken POS en http://127.0.0.1:{DASHBOARD_PORT}")
    server.serve_forever()


if __name__ == "__main__":
    main()
