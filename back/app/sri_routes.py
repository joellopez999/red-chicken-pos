"""
Ecuador SRI electronic invoicing endpoints, plus the "manual invoice" order
type whose only purpose is to be invoiced (see docs/0075 and the plan that
shipped it). Split out of main.py as part of breaking up that monolith —
these endpoints previously lived at lines ~13932 and ~15007-15301.
"""

import logging
from datetime import datetime, timezone
from pathlib import Path
from typing import Annotated, Any

from fastapi import APIRouter, Depends, HTTPException, Request, Response
from fastapi.responses import FileResponse, StreamingResponse
from sqlmodel import Session, select

from . import models, tenant_secrets
from .db import get_session
from .fiscal_invoice_service import order_fiscal_amount_cents
from .permissions import Permission, require_permission
from .rate_limits import _rate_limit_key_user, limiter
from .settings import settings
from .sri_invoice_service import (
    generar_clave_acceso,
    generar_ride_pdf,
    generar_xml_factura,
    get_or_create_manual_line_placeholder,
    sri_comprobante_public_dict,
)
from .sri_providers import enviar_recepcion
from .sri_signing import EC_TZ, load_p12, sign_factura_xml
from .staff_action_log import log_staff_action

logger = logging.getLogger(__name__)
router = APIRouter()

UPLOADS_DIR = Path(__file__).parent.parent / "uploads"


@router.post("/orders/manual-invoice")
@limiter.limit(f"{getattr(settings, 'rate_limit_admin_per_minute', 30)}/minute", key_func=_rate_limit_key_user)
def create_manual_invoice_order(
    request: Request,
    response: Response,
    body: models.ManualInvoiceCreate,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """Staff: create a standalone sale (no table, no delivery) whose only purpose is to issue
    a fiscal (SRI) invoice — e.g. a service, or a sale that didn't go through the normal order
    flow. Items are either real menu products or free-text lines (see ManualInvoiceLine)."""
    if not body.lines:
        raise HTTPException(status_code=400, detail="At least one line is required")

    billing_customer = None
    if body.billing_customer_id is not None:
        billing_customer = session.exec(
            select(models.BillingCustomer).where(
                models.BillingCustomer.id == body.billing_customer_id,
                models.BillingCustomer.tenant_id == current_user.tenant_id,
            )
        ).first()
        if not billing_customer:
            raise HTTPException(status_code=404, detail="Billing customer not found")

    # Resolve and validate every line BEFORE creating anything, so a bad line never leaves
    # behind an empty/partial order.
    # Sanity caps on a hand-typed fiscal document: a fat-fingered quantity/amount produces a
    # real SRI invoice that can't be easily undone, so bound both rather than trusting the input.
    MAX_MANUAL_LINE_QUANTITY = 999
    MAX_MANUAL_LINE_AMOUNT_CENTS = 100_000_00  # $100,000 per line
    MAX_MANUAL_LINE_DESCRIPTION_LENGTH = 300

    resolved: list[dict[str, Any]] = []
    for line in body.lines:
        if line.quantity < 1 or line.quantity > MAX_MANUAL_LINE_QUANTITY:
            raise HTTPException(status_code=400, detail=f"quantity must be between 1 and {MAX_MANUAL_LINE_QUANTITY}")
        quantity = line.quantity
        if line.type == "product":
            if not line.product_id:
                raise HTTPException(status_code=400, detail="product_id is required for product lines")
            product = session.exec(
                select(models.Product).where(
                    models.Product.id == line.product_id,
                    models.Product.tenant_id == current_user.tenant_id,
                )
            ).first()
            if not product or product.is_manual_invoice_placeholder:
                raise HTTPException(status_code=400, detail=f"Product not found: {line.product_id}")
            resolved.append({
                "product_id": product.id,
                "product_name": product.name,
                "quantity": quantity,
                "price_cents": product.price_cents,
            })
        elif line.type == "custom":
            description = (line.description or "").strip()[:MAX_MANUAL_LINE_DESCRIPTION_LENGTH]
            if not description:
                raise HTTPException(status_code=400, detail="description is required for custom lines")
            if not line.amount_cents or line.amount_cents <= 0 or line.amount_cents > MAX_MANUAL_LINE_AMOUNT_CENTS:
                raise HTTPException(
                    status_code=400,
                    detail=f"amount_cents must be between 1 and {MAX_MANUAL_LINE_AMOUNT_CENTS} for custom lines",
                )
            resolved.append({
                "product_id": None,  # filled in below once the placeholder exists
                "product_name": description,
                "quantity": quantity,
                "price_cents": line.amount_cents,
            })
        else:
            raise HTTPException(status_code=400, detail=f"Unknown line type: {line.type}")

    if any(r["product_id"] is None for r in resolved):
        placeholder = get_or_create_manual_line_placeholder(session, current_user.tenant_id)
        for r in resolved:
            if r["product_id"] is None:
                r["product_id"] = placeholder.id

    order = models.Order(
        tenant_id=current_user.tenant_id,
        table_id=None,
        order_channel=models.OrderChannel.manual_invoice,
        status=models.OrderStatus.paid,
        customer_name=body.customer_name or (billing_customer.name if billing_customer else None),
        billing_customer_id=billing_customer.id if billing_customer else None,
        paid_at=datetime.now(timezone.utc),
        payment_method="manual_invoice",
    )
    session.add(order)
    session.flush()  # get order.id without a second round trip

    for r in resolved:
        session.add(models.OrderItem(
            order_id=order.id,
            product_id=r["product_id"],
            product_name=r["product_name"],
            quantity=r["quantity"],
            price_cents=r["price_cents"],
            status=models.OrderItemStatus.delivered,
        ))
    session.commit()
    session.refresh(order)

    return {
        "id": order.id,
        "status": order.status.value,
        "order_channel": order.order_channel.value,
        "customer_name": order.customer_name,
        "billing_customer_id": order.billing_customer_id,
        "created_at": order.created_at.isoformat() if order.created_at else None,
    }


@router.get("/orders/{order_id}/sri-invoice")
def get_order_sri_invoice(
    order_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_READ))],
    session: Session = Depends(get_session),
) -> dict:
    """Return persisted SRI comprobante status for an order (tenant-scoped); poll until estado is AUT/NAT."""
    order = session.exec(
        select(models.Order).where(
            models.Order.id == order_id,
            models.Order.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not order or order.deleted_at is not None:
        raise HTTPException(status_code=404, detail="Order not found")
    row = session.exec(
        select(models.SriComprobante).where(
            models.SriComprobante.order_id == order.id,
            models.SriComprobante.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not row:
        raise HTTPException(status_code=404, detail="SRI invoice not found")
    return sri_comprobante_public_dict(row)


@router.post("/orders/{order_id}/sri-invoice/issue")
@limiter.limit(f"{getattr(settings, 'rate_limit_admin_per_minute', 30)}/minute", key_func=_rate_limit_key_user)
def issue_order_sri_invoice(
    request: Request,
    response: Response,
    order_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """Generate, sign (XAdES-BES) and submit (Recepción) a factura for the order.
    Idempotent per order. Authorization is asynchronous — the background worker
    (sri_authorization_worker.py) polls SRI and flips estado to AUT/NAT; the client
    should poll GET /orders/{order_id}/sri-invoice until it does.
    """
    tenant = session.exec(select(models.Tenant).where(models.Tenant.id == current_user.tenant_id)).first()
    if not tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    if tenant.sri_mode == "off":
        raise HTTPException(status_code=400, detail="La facturación SRI no está habilitada para este negocio")
    if not tenant.sri_ruc or not tenant.sri_certificate_filename or not tenant.sri_certificate_password:
        raise HTTPException(status_code=400, detail="Falta configurar RUC y/o certificado SRI en Ajustes")

    order = session.exec(
        select(models.Order).where(
            models.Order.id == order_id,
            models.Order.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not order or order.deleted_at is not None:
        raise HTTPException(status_code=404, detail="Order not found")

    active_items = session.exec(
        select(models.OrderItem).where(
            models.OrderItem.order_id == order.id,
            models.OrderItem.removed_by_customer == False,  # noqa: E712
            models.OrderItem.removed_by_user_id.is_(None),
            models.OrderItem.status != models.OrderItemStatus.cancelled,
        )
    ).all()
    if not active_items:
        raise HTTPException(status_code=400, detail="El pedido no tiene ítems para facturar")
    if order_fiscal_amount_cents(session, order) <= 0:
        raise HTTPException(status_code=400, detail="El total del pedido es cero; no se puede facturar")

    existing = session.exec(
        select(models.SriComprobante).where(
            models.SriComprobante.order_id == order.id,
            models.SriComprobante.tenant_id == current_user.tenant_id,
        )
    ).first()
    # Idempotent once accepted for processing or authorized (PPR/RECIBIDA/AUT) — but a
    # rejected submission (DEVUELTA at recepción, NAT at autorización) must be retried with
    # the SAME clave de acceso and secuencial per the Ficha Técnica §9 note 1 ("sin generar
    # nuevos números"), once the underlying data problem has been fixed.
    if existing and existing.estado not in ("DEVUELTA", "NAT"):
        return sri_comprobante_public_dict(existing)

    cert_path = UPLOADS_DIR / str(tenant.id) / "sri" / tenant.sri_certificate_filename
    if not cert_path.is_file():
        raise HTTPException(status_code=400, detail="Certificado SRI no encontrado; vuelve a subirlo en Ajustes")

    ambiente = 1 if tenant.sri_mode == "pruebas" else 2
    if existing and existing.estado == "DEVUELTA":
        # DEVUELTA = rejected at Recepción, before SRI ever registered the clave — safe to
        # resend the same clave/secuencial (Ficha Técnica §9 note 1).
        clave_acceso = existing.clave_acceso
        secuencial = int(existing.secuencial)
    else:
        # existing.estado == "NAT" (or no existing row): once a comprobante is RECIBIDA, SRI
        # permanently registers that clave/secuencial even if later NOT AUTORIZADO — confirmed
        # live (error 43 "CLAVE ACCESO REGISTRADA" on reusing a NAT clave) — so a NAT retry
        # needs a brand-new secuencial, same as a fresh issuance.
        secuencial = tenant.sri_secuencial_factura
        clave_acceso = generar_clave_acceso(
            fecha_emision=datetime.now(EC_TZ).date(),
            ruc=tenant.sri_ruc,
            ambiente=ambiente,
            establecimiento=tenant.sri_establecimiento,
            punto_emision=tenant.sri_punto_emision,
            secuencial=secuencial,
        )
    xml_sin_firma = generar_xml_factura(session, tenant, order, clave_acceso, secuencial)

    try:
        cert_bytes = tenant_secrets.decrypt_bytes(cert_path.read_bytes(), tenant_secrets.SRI_CERT_FILE_DOMAIN)
        cert_password = tenant_secrets.decrypt_secret(tenant.sri_certificate_password, tenant_secrets.SRI_CERT_PASSWORD_DOMAIN)
        private_key, certificate = load_p12(cert_bytes, cert_password)
        xml_firmado = sign_factura_xml(xml_sin_firma, private_key, certificate)
    except Exception as e:
        logger.error("SRI signing failed for order %s: %s", order.id, e, exc_info=True)
        log_staff_action(
            session,
            tenant_id=current_user.tenant_id,
            user_id=current_user.id,
            user_email=current_user.email,
            action_type="sri_invoice_issue",
            summary=f"Factura SRI para pedido #{order.id}: fallo al firmar",
            detail={"order_id": order.id},
            success=False,
            error_message=str(e),
            request_path="/orders/{order_id}/sri-invoice/issue",
        )
        raise HTTPException(status_code=500, detail="No se pudo firmar el comprobante") from e

    try:
        recepcion = enviar_recepcion(xml_firmado.encode("utf-8"), ambiente)
    except Exception as e:
        logger.error("SRI recepción failed for order %s: %s", order.id, e, exc_info=True)
        log_staff_action(
            session,
            tenant_id=current_user.tenant_id,
            user_id=current_user.id,
            user_email=current_user.email,
            action_type="sri_invoice_issue",
            summary=f"Factura SRI para pedido #{order.id}: no se pudo contactar al SRI",
            detail={"order_id": order.id},
            success=False,
            error_message=str(e),
            request_path="/orders/{order_id}/sri-invoice/issue",
        )
        raise HTTPException(status_code=502, detail="No se pudo contactar al SRI") from e

    row = existing or models.SriComprobante(
        tenant_id=tenant.id,
        order_id=order.id,
        ambiente=ambiente,
        clave_acceso=clave_acceso,
        secuencial=f"{secuencial:09d}",
    )
    row.estado = recepcion.estado or "DEVUELTA"
    row.xml_firmado = xml_firmado
    row.xml_autorizado = None
    row.numero_autorizacion = None
    row.fecha_autorizacion = None
    row.mensajes_error = {"mensajes": recepcion.mensajes} if recepcion.mensajes else None
    row.amount_cents = order_fiscal_amount_cents(session, order)
    row.submitted_at = datetime.now(timezone.utc)
    session.add(row)
    # Only advance the sequential counter the first time THIS secuencial is actually accepted
    # (RECIBIDA) — a rejected attempt (DEVUELTA/NAT, including a retry that reuses the same
    # secuencial per Ficha Técnica §9 note 1) must not burn/re-burn a sequential number.
    if recepcion.estado == "RECIBIDA" and tenant.sri_secuencial_factura == secuencial:
        tenant.sri_secuencial_factura = secuencial + 1
        session.add(tenant)
    session.commit()
    session.refresh(row)
    log_staff_action(
        session,
        tenant_id=current_user.tenant_id,
        user_id=current_user.id,
        user_email=current_user.email,
        action_type="sri_invoice_issue",
        summary=f"Factura SRI para pedido #{order.id}: {row.estado}",
        detail={"order_id": order.id, "clave_acceso": row.clave_acceso, "estado": row.estado},
        success=row.estado != "DEVUELTA",
        error_message=None if row.estado != "DEVUELTA" else str(row.mensajes_error),
        request_path="/orders/{order_id}/sri-invoice/issue",
    )
    return sri_comprobante_public_dict(row)


@router.get("/orders/{order_id}/sri-invoice/ride")
def download_order_sri_ride(
    order_id: int,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_READ))],
    session: Session = Depends(get_session),
):
    """RIDE (representación impresa) PDF — available once a comprobante has been submitted,
    even before authorization (marked PENDIENTE in that case). Once AUT, the worker saves a
    permanent copy to disk (see sri_authorization_worker.ride_pdf_path); served from there
    when present so the exact authorized document stays retrievable, else generated fresh."""
    order = session.exec(
        select(models.Order).where(
            models.Order.id == order_id,
            models.Order.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not order or order.deleted_at is not None:
        raise HTTPException(status_code=404, detail="Order not found")
    row = session.exec(
        select(models.SriComprobante).where(
            models.SriComprobante.order_id == order.id,
            models.SriComprobante.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not row:
        raise HTTPException(status_code=404, detail="SRI invoice not found")

    from app.sri_authorization_worker import ride_pdf_path

    saved_path = ride_pdf_path(row.tenant_id, row.clave_acceso)
    if saved_path.is_file():
        return FileResponse(
            saved_path,
            media_type="application/pdf",
            filename=f"factura-{row.clave_acceso}.pdf",
        )

    buffer = generar_ride_pdf(row)
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'inline; filename="factura-{row.clave_acceso}.pdf"'},
    )


@router.post("/orders/{order_id}/sri-invoice/send-email")
@limiter.limit(f"{getattr(settings, 'rate_limit_admin_per_minute', 30)}/minute", key_func=_rate_limit_key_user)
def send_order_sri_invoice_email(
    request: Request,
    response: Response,
    order_id: int,
    body: models.SriInvoiceEmailRequest,
    current_user: Annotated[models.User, Depends(require_permission(Permission.ORDER_UPDATE_STATUS))],
    session: Session = Depends(get_session),
) -> dict:
    """Manually (re)send the authorized invoice by email via Resend. Only available once AUT."""
    tenant = session.exec(select(models.Tenant).where(models.Tenant.id == current_user.tenant_id)).first()
    if not tenant or not (tenant.resend_api_key or "").strip():
        raise HTTPException(status_code=400, detail="Resend no está configurado en Ajustes")

    order = session.exec(
        select(models.Order).where(
            models.Order.id == order_id,
            models.Order.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not order or order.deleted_at is not None:
        raise HTTPException(status_code=404, detail="Order not found")

    row = session.exec(
        select(models.SriComprobante).where(
            models.SriComprobante.order_id == order.id,
            models.SriComprobante.tenant_id == current_user.tenant_id,
        )
    ).first()
    if not row or row.estado != "AUT":
        raise HTTPException(status_code=400, detail="La factura todavía no está autorizada")

    email = (body.email or "").strip()
    name = None
    if not email and order.billing_customer_id:
        billing_customer = session.get(models.BillingCustomer, order.billing_customer_id)
        if billing_customer and billing_customer.email:
            email = billing_customer.email
            name = billing_customer.name
    if not email:
        raise HTTPException(status_code=400, detail="No hay un correo del cliente; indícalo manualmente")

    from app.sri_authorization_worker import ride_pdf_path

    saved_path = ride_pdf_path(row.tenant_id, row.clave_acceso)
    pdf_bytes = saved_path.read_bytes() if saved_path.is_file() else generar_ride_pdf(row).read()

    from app.resend_service import send_invoice_email

    sent = send_invoice_email(
        tenant, email, name, row, pdf_bytes,
        row.xml_autorizado.encode("utf-8") if row.xml_autorizado else None,
    )
    if not sent:
        raise HTTPException(status_code=502, detail="No se pudo enviar el correo (revisa la API key de Resend)")

    row.email_sent_at = datetime.now(timezone.utc)
    session.add(row)
    session.commit()
    session.refresh(row)
    return sri_comprobante_public_dict(row)
