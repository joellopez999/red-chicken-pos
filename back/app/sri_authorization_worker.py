"""Background worker: polls SRI's Autorización web service for comprobantes still
en procesamiento (PPR) or just recibidos (RECIBIDA) — authorization is not
synchronous, per the Ficha Técnica (§5.10-5.11, up to 24h in edge cases).
"""

from __future__ import annotations

import asyncio
import logging
from datetime import datetime, timezone
from pathlib import Path

from sqlmodel import Session, select

from app import models
from app.db import engine
from app.resend_service import send_invoice_email
from app.sri_invoice_service import generar_ride_pdf
from app.sri_providers import consultar_autorizacion

logger = logging.getLogger(__name__)

TICK_SECONDS = 20
PENDING_STATES = ("PPR", "RECIBIDA")
BATCH_LIMIT = 10
UPLOADS_DIR = Path(__file__).resolve().parents[1] / "uploads"


def ride_pdf_path(tenant_id: int, clave_acceso: str) -> Path:
    return UPLOADS_DIR / str(tenant_id) / "sri" / "ride" / f"{clave_acceso}.pdf"


def _save_ride_pdf(row: models.SriComprobante) -> bytes | None:
    try:
        path = ride_pdf_path(row.tenant_id, row.clave_acceso)
        path.parent.mkdir(parents=True, exist_ok=True)
        pdf_bytes = generar_ride_pdf(row).read()
        path.write_bytes(pdf_bytes)
        return pdf_bytes
    except Exception as e:
        logger.warning("Failed to save RIDE PDF for %s: %s", row.clave_acceso, e)
        return None


def _send_invoice_email_if_configured(session: Session, row: models.SriComprobante, pdf_bytes: bytes | None) -> None:
    if not pdf_bytes:
        return
    tenant = session.get(models.Tenant, row.tenant_id)
    if not tenant or not (tenant.resend_api_key or "").strip():
        return
    order = session.get(models.Order, row.order_id)
    if not order or not order.billing_customer_id:
        return
    billing_customer = session.get(models.BillingCustomer, order.billing_customer_id)
    if not billing_customer or not billing_customer.email:
        return
    sent = send_invoice_email(
        tenant, billing_customer.email, billing_customer.name, row, pdf_bytes,
        row.xml_autorizado.encode("utf-8") if row.xml_autorizado else None,
    )
    if sent:
        row.email_sent_at = datetime.now(timezone.utc)
        session.add(row)
        session.commit()


def _tick_sync() -> int:
    processed = 0
    with Session(engine) as session:
        rows = session.exec(
            select(models.SriComprobante)
            .where(models.SriComprobante.estado.in_(PENDING_STATES))
            .order_by(models.SriComprobante.submitted_at)
            .limit(BATCH_LIMIT)
        ).all()
        for row in rows:
            try:
                result = consultar_autorizacion(row.clave_acceso, row.ambiente)
            except Exception as e:
                logger.warning("SRI autorización check failed for %s: %s", row.clave_acceso, e)
                continue
            row.last_checked_at = datetime.now(timezone.utc)
            if result.estado in ("AUT", "NAT"):
                row.estado = result.estado
                row.numero_autorizacion = result.numero_autorizacion
                row.xml_autorizado = result.comprobante_autorizado_xml
                if result.mensajes:
                    row.mensajes_error = {"mensajes": result.mensajes}
                if result.fecha_autorizacion:
                    try:
                        row.fecha_autorizacion = datetime.fromisoformat(result.fecha_autorizacion)
                    except ValueError:
                        row.fecha_autorizacion = datetime.now(timezone.utc)
                processed += 1
            session.add(row)
            session.commit()
            if row.estado == "AUT":
                session.refresh(row)
                pdf_bytes = _save_ride_pdf(row)
                _send_invoice_email_if_configured(session, row, pdf_bytes)
    return processed


async def sri_authorization_worker_loop(stop: asyncio.Event | None = None) -> None:
    stop_ev = stop or asyncio.Event()
    while not stop_ev.is_set():
        try:
            n = await asyncio.to_thread(_tick_sync)
            if n > 0:
                logger.info("SRI authorization worker: resolved %d comprobante(s) this tick", n)
        except Exception as e:
            logger.warning("SRI authorization worker tick failed: %s", e, exc_info=True)
        try:
            await asyncio.wait_for(stop_ev.wait(), timeout=float(TICK_SECONDS))
        except asyncio.TimeoutError:
            pass
