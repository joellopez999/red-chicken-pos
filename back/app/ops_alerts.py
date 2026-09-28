"""Alertas operativas por correo: avisa a los mismos 2 correos de respaldo del 2FA
(OTP_BACKUP_EMAILS) cuando el sistema se cae o tira un error inesperado, para que
alguien se entere aunque nadie esté viendo los logs del servidor en ese momento.

Despliegue de un solo tenant real (Red Chicken) — se envía siempre con la llave
de Resend de tenant_id=1, sin intentar resolver un tenant "correcto" por request
(no tiene sentido para una alerta de infraestructura, no de negocio).
"""
from __future__ import annotations

import logging
import time

from sqlmodel import Session

from . import models, resend_service
from .db import engine
from .settings import settings

logger = logging.getLogger(__name__)

_ALERT_COOLDOWN_SECONDS = 15 * 60
_last_sent_at: dict[str, float] = {}
_ALERT_TENANT_ID = 1


def _recipients() -> list[str]:
    return [e.strip() for e in (settings.otp_backup_emails or "").split(",") if e.strip()]


def notify_ops_error(kind: str, detail: str) -> None:
    """Envío de mejor esfuerzo — nunca lanza. Una falla aquí no debe afectar la
    respuesta de error que ya se le está devolviendo al usuario."""
    now = time.monotonic()
    if now - _last_sent_at.get(kind, 0.0) < _ALERT_COOLDOWN_SECONDS:
        return
    try:
        recipients = _recipients()
        if not recipients:
            return
        with Session(engine) as session:
            tenant = session.get(models.Tenant, _ALERT_TENANT_ID)
        if not tenant:
            return
        html = f"<p><strong>{kind}</strong></p><p>{detail}</p>"
        if resend_service.send_simple_email(tenant, recipients, f"Red Chicken POS — {kind}", html):
            _last_sent_at[kind] = now
    except Exception:
        logger.exception("No se pudo enviar la alerta operativa (%s)", kind)
