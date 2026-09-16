"""Send the authorized SRI invoice (RIDE PDF + authorized XML) to the customer via Resend
(resend.com). The SRI's own ficha técnica makes this the emisor's obligation — authorization
alone never notifies the receptor (see docs/0075-sri-ecuador-invoicing.md).

Separate from the existing SMTP-based email_service.py: Resend is an HTTP API, not SMTP, and
is specifically opt-in per tenant (Tenant.resend_api_key) for this one use case.
"""

from __future__ import annotations

import base64
import logging

import requests

from app import models

logger = logging.getLogger(__name__)

RESEND_API_URL = "https://api.resend.com/emails"
DEFAULT_FROM = "onboarding@resend.dev"  # Resend's shared test sender; verify a real domain for production.


def send_invoice_email(
    tenant: models.Tenant,
    to_email: str,
    to_name: str | None,
    comprobante: models.SriComprobante,
    ride_pdf_bytes: bytes,
    xml_bytes: bytes | None,
) -> bool:
    api_key = (tenant.resend_api_key or "").strip()
    if not api_key or not to_email:
        return False

    from_email = (tenant.email_from or "").strip() or DEFAULT_FROM
    from_name = (tenant.email_from_name or tenant.name or "Facturación").strip()
    recipient = f"{to_name} <{to_email}>" if to_name else to_email

    attachments = [
        {
            "filename": f"factura-{comprobante.clave_acceso}.pdf",
            "content": base64.b64encode(ride_pdf_bytes).decode("ascii"),
            "content_type": "application/pdf",
        }
    ]
    if xml_bytes:
        attachments.append({
            "filename": f"factura-{comprobante.clave_acceso}.xml",
            "content": base64.b64encode(xml_bytes).decode("ascii"),
            "content_type": "application/xml",
        })

    html = f"""
    <p>Adjuntamos su factura electrónica autorizada por el SRI.</p>
    <p><b>Número de autorización:</b> {comprobante.numero_autorizacion or comprobante.clave_acceso}</p>
    <p><b>Total:</b> ${comprobante.amount_cents / 100:.2f}</p>
    """

    try:
        response = requests.post(
            RESEND_API_URL,
            headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
            json={
                "from": f"{from_name} <{from_email}>",
                "to": [recipient],
                "subject": f"Factura electrónica — {tenant.name}",
                "html": html,
                "attachments": attachments,
            },
            timeout=15,
        )
        if response.status_code >= 300:
            logger.warning("Resend invoice email failed (%s): %s", response.status_code, response.text[:500])
            return False
        return True
    except Exception as e:
        logger.warning("Resend invoice email request failed: %s", e)
        return False
