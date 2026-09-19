#!/usr/bin/env python3
"""Panel local de control/estado para Red Chicken POS. Solo stdlib, sin dependencias.

Escucha en 127.0.0.1 (no expuesto a la red) y expone:
  GET  /              -> dashboard HTML
  GET  /api/status     -> JSON con estado de contenedores, tailscale, disco y negocio
  POST /api/action     -> {"action": "start"|"stop"|"restart"} sobre el stack docker compose
"""

import json
import re
import shutil
import subprocess
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
    server = ThreadingHTTPServer(("127.0.0.1", DASHBOARD_PORT), Handler)
    print(f"Panel Red Chicken POS en http://127.0.0.1:{DASHBOARD_PORT}")
    server.serve_forever()


if __name__ == "__main__":
    main()
