"""Ecuador SRI electronic invoicing (comprobantes electrónicos) — factura generation.

Implements the exact "clave de acceso" (49-digit access key) algorithm and the
factura XML schema (version 1.0.0) from the SRI's official technical spec
("Ficha Técnica: Emisión de Comprobantes Electrónicos", Anexo 1). XAdES-BES
signing and SOAP submission live in sri_signing.py / sri_providers.py — this
module only builds the unsigned document and the access key.
"""

from __future__ import annotations

import secrets
from datetime import date, datetime, timezone
from io import BytesIO
from xml.etree import ElementTree
from xml.sax.saxutils import escape

import barcode as barcode_lib
from barcode.writer import ImageWriter
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.platypus import Image, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle
from sqlmodel import Session, select

from app import models
from app.fiscal_invoice_service import order_fiscal_amount_cents
from app.sri_signing import EC_TZ

CODIGO_IMPUESTO_IVA = "2"  # Tabla 16
CODIGO_PORCENTAJE_IVA_0 = "0"  # Tabla 18 — IVA 0%
TIPO_COMPROBANTE_FACTURA = "01"  # Tabla 3
TIPO_EMISION_NORMAL = "1"  # Tabla 2
AMBIENTE_PRUEBAS = 1
AMBIENTE_PRODUCCION = 2
TIPO_IDENTIFICACION_RUC = "04"
TIPO_IDENTIFICACION_CEDULA = "05"
TIPO_IDENTIFICACION_CONSUMIDOR_FINAL = "07"
IDENTIFICACION_CONSUMIDOR_FINAL = "9999999999999"


def modulo11(digits: str) -> int:
    """Ecuador SRI check-digit algorithm: weighted factor 2..7 cycling from the
    rightmost digit. Verified against the official worked example: modulo11("41261533") == 6.
    """
    weights = [2, 3, 4, 5, 6, 7]
    total = 0
    for i, ch in enumerate(reversed(digits)):
        total += int(ch) * weights[i % 6]
    remainder = total % 11
    check = 11 - remainder
    if check == 11:
        return 0
    if check == 10:
        return 1
    return check


def generar_clave_acceso(
    *,
    fecha_emision: date,
    ruc: str,
    ambiente: int,
    establecimiento: str,
    punto_emision: str,
    secuencial: int,
    tipo_comprobante: str = TIPO_COMPROBANTE_FACTURA,
    tipo_emision: str = TIPO_EMISION_NORMAL,
    codigo_numerico: str | None = None,
) -> str:
    ruc_digits = "".join(ch for ch in (ruc or "") if ch.isdigit())
    if len(ruc_digits) != 13:
        raise ValueError(f"RUC must be 13 digits, got {ruc_digits!r}")
    if ambiente not in (AMBIENTE_PRUEBAS, AMBIENTE_PRODUCCION):
        raise ValueError(f"ambiente must be 1 (pruebas) or 2 (producción), got {ambiente}")
    serie = f"{establecimiento.zfill(3)}{punto_emision.zfill(3)}"
    if len(serie) != 6:
        raise ValueError("establecimiento/punto_emision must each be 3 digits")
    secuencial_str = str(secuencial).zfill(9)
    if len(secuencial_str) != 9:
        raise ValueError(f"secuencial too large for 9 digits: {secuencial}")
    if codigo_numerico is None:
        codigo_numerico = f"{secrets.randbelow(10**8):08d}"
    base = (
        f"{fecha_emision.strftime('%d%m%Y')}"
        f"{tipo_comprobante}"
        f"{ruc_digits}"
        f"{ambiente}"
        f"{serie}"
        f"{secuencial_str}"
        f"{codigo_numerico}"
        f"{tipo_emision}"
    )
    if len(base) != 48:
        raise ValueError(f"internal error: clave base is {len(base)} digits, expected 48")
    return f"{base}{modulo11(base)}"


def _fmt_money(cents: int) -> str:
    return f"{cents / 100:.2f}"


def _comprador_identificacion(order: models.Order, billing_customer: models.BillingCustomer | None) -> tuple[str, str, str | None]:
    """Returns (tipo_identificacion, identificacion, direccion) for infoFactura."""
    if billing_customer and billing_customer.tax_id:
        tax_id = "".join(ch for ch in billing_customer.tax_id if ch.isalnum())
        tipo = TIPO_IDENTIFICACION_RUC if len(tax_id) == 13 else TIPO_IDENTIFICACION_CEDULA
        return tipo, tax_id, billing_customer.address
    return TIPO_IDENTIFICACION_CONSUMIDOR_FINAL, IDENTIFICACION_CONSUMIDOR_FINAL, None


def _razon_social_comprador(
    tipo_id_comprador: str, order: models.Order, billing_customer: models.BillingCustomer | None
) -> str:
    # SRI requires the literal text "CONSUMIDOR FINAL" whenever the generic consumidor-final
    # identification (07 / 9999999999999) is used — using the customer's real name there
    # triggers error 69 "ERROR EN LA IDENTIFICACION DEL RECEPTOR" (confirmed live).
    if tipo_id_comprador == TIPO_IDENTIFICACION_CONSUMIDOR_FINAL:
        return "CONSUMIDOR FINAL"
    if billing_customer:
        return billing_customer.company_name or billing_customer.name
    return order.customer_name or "CONSUMIDOR FINAL"


def generar_xml_factura(
    session: Session,
    tenant: models.Tenant,
    order: models.Order,
    clave_acceso: str,
    secuencial: int,
) -> str:
    """Builds the unsigned factura XML (Anexo 1, versión 1.0.0). IVA is applied at
    0% (CODIGO_PORCENTAJE_IVA_0) per the tenant's confirmed tax regime — do not
    change this without confirming the current SRI rate code for a different tariff.
    """
    items = session.exec(select(models.OrderItem).where(models.OrderItem.order_id == order.id)).all()
    active = [
        i for i in items
        if not i.removed_by_customer and i.removed_by_user_id is None
        and i.status != models.OrderItemStatus.cancelled
    ]
    billing_customer = session.get(models.BillingCustomer, order.billing_customer_id) if order.billing_customer_id else None

    subtotal_cents = sum(i.price_cents * i.quantity for i in active)
    total_cents = order_fiscal_amount_cents(session, order)
    tipo_id_comprador, ident_comprador, dir_comprador = _comprador_identificacion(order, billing_customer)
    razon_social_comprador = _razon_social_comprador(tipo_id_comprador, order, billing_customer)

    detalles_xml = []
    for item in active:
        line_total_cents = item.price_cents * item.quantity
        detalles_xml.append(
            "<detalle>"
            f"<codigoPrincipal>{escape(str(item.product_id))}</codigoPrincipal>"
            f"<descripcion>{escape(item.product_name[:300])}</descripcion>"
            f"<cantidad>{item.quantity:.2f}</cantidad>"
            f"<precioUnitario>{_fmt_money(item.price_cents)}</precioUnitario>"
            f"<descuento>{_fmt_money(item.discount_cents * item.quantity)}</descuento>"
            f"<precioTotalSinImpuesto>{_fmt_money(line_total_cents)}</precioTotalSinImpuesto>"
            "<impuestos>"
            "<impuesto>"
            f"<codigo>{CODIGO_IMPUESTO_IVA}</codigo>"
            f"<codigoPorcentaje>{CODIGO_PORCENTAJE_IVA_0}</codigoPorcentaje>"
            "<tarifa>0</tarifa>"
            f"<baseImponible>{_fmt_money(line_total_cents)}</baseImponible>"
            "<valor>0.00</valor>"
            "</impuesto>"
            "</impuestos>"
            "</detalle>"
        )

    direccion_comprador_xml = (
        f"<direccionComprador>{escape(dir_comprador[:300])}</direccionComprador>" if dir_comprador else ""
    )
    nombre_comercial_xml = (
        f"<nombreComercial>{escape(tenant.sri_nombre_comercial[:300])}</nombreComercial>"
        if tenant.sri_nombre_comercial else ""
    )
    dir_establecimiento_xml = (
        f"<dirEstablecimiento>{escape(tenant.address[:300])}</dirEstablecimiento>" if tenant.address else ""
    )

    xml = (
        '<?xml version="1.0" encoding="UTF-8"?>'
        '<factura id="comprobante" version="1.0.0">'
        "<infoTributaria>"
        f"<ambiente>{AMBIENTE_PRUEBAS if tenant.sri_mode == 'pruebas' else AMBIENTE_PRODUCCION}</ambiente>"
        f"<tipoEmision>{TIPO_EMISION_NORMAL}</tipoEmision>"
        f"<razonSocial>{escape((tenant.sri_razon_social or tenant.name)[:300])}</razonSocial>"
        f"{nombre_comercial_xml}"
        f"<ruc>{tenant.sri_ruc}</ruc>"
        f"<claveAcceso>{clave_acceso}</claveAcceso>"
        f"<codDoc>{TIPO_COMPROBANTE_FACTURA}</codDoc>"
        f"<estab>{tenant.sri_establecimiento}</estab>"
        f"<ptoEmi>{tenant.sri_punto_emision}</ptoEmi>"
        f"<secuencial>{secuencial:09d}</secuencial>"
        f"<dirMatriz>{escape((tenant.sri_direccion_matriz or tenant.address or '')[:300])}</dirMatriz>"
        "</infoTributaria>"
        "<infoFactura>"
        f"<fechaEmision>{datetime.now(EC_TZ).strftime('%d/%m/%Y')}</fechaEmision>"
        f"{dir_establecimiento_xml}"
        f"<obligadoContabilidad>{'SI' if tenant.sri_obligado_contabilidad else 'NO'}</obligadoContabilidad>"
        f"<tipoIdentificacionComprador>{tipo_id_comprador}</tipoIdentificacionComprador>"
        f"<razonSocialComprador>{escape(razon_social_comprador[:300])}</razonSocialComprador>"
        f"<identificacionComprador>{ident_comprador}</identificacionComprador>"
        f"{direccion_comprador_xml}"
        f"<totalSinImpuestos>{_fmt_money(subtotal_cents)}</totalSinImpuestos>"
        "<totalDescuento>0.00</totalDescuento>"
        "<totalConImpuestos>"
        "<totalImpuesto>"
        f"<codigo>{CODIGO_IMPUESTO_IVA}</codigo>"
        f"<codigoPorcentaje>{CODIGO_PORCENTAJE_IVA_0}</codigoPorcentaje>"
        f"<baseImponible>{_fmt_money(subtotal_cents)}</baseImponible>"
        "<valor>0.00</valor>"
        "</totalImpuesto>"
        "</totalConImpuestos>"
        f"<propina>0.00</propina>"
        f"<importeTotal>{_fmt_money(total_cents)}</importeTotal>"
        "<moneda>DOLAR</moneda>"
        "<pagos><pago>"
        f"<formaPago>{_forma_pago(order)}</formaPago>"
        f"<total>{_fmt_money(total_cents)}</total>"
        "</pago></pagos>"
        "</infoFactura>"
        f"<detalles>{''.join(detalles_xml)}</detalles>"
        "</factura>"
    )
    return xml


def _forma_pago(order: models.Order) -> str:
    """Tabla 24 (forma de pago) — best-effort mapping; "01" (sin utilización del
    sistema financiero) is a safe default for cash/unspecified."""
    method = (order.payment_method or "").lower()
    if method in ("stripe", "revolut", "terminal", "card"):
        return "19"  # tarjeta de crédito (approximate; confirm current Tabla 24 if this matters to reporting)
    return "01"


def generar_ride_pdf(comprobante: models.SriComprobante) -> BytesIO:
    """Renders the RIDE (representación impresa del documento electrónico) from the
    authorized XML when available, else the last-submitted signed XML."""
    xml_source = comprobante.xml_autorizado or comprobante.xml_firmado
    root = ElementTree.fromstring(xml_source)

    def text(path: str, default: str = "") -> str:
        el = root.find(path)
        # escape() guards against reportlab's Paragraph mini-markup (<font>, <b>, ...)
        # being triggered by a customer/product name that happens to contain <, >, or &.
        return escape(el.text) if el is not None and el.text else default

    razon_social = text("infoTributaria/razonSocial")
    ruc = text("infoTributaria/ruc")
    clave_acceso = text("infoTributaria/claveAcceso", comprobante.clave_acceso)
    numero_factura = f"{text('infoTributaria/estab')}-{text('infoTributaria/ptoEmi')}-{text('infoTributaria/secuencial')}"

    styles = getSampleStyleSheet()
    h1 = ParagraphStyle("RideTitle", parent=styles["Heading1"], fontSize=14)
    normal = styles["Normal"]
    small = ParagraphStyle("RideSmall", parent=styles["Normal"], fontSize=8)

    elements = [
        Paragraph(razon_social or "—", h1),
        Paragraph(f"RUC: {ruc}", normal),
        Paragraph(text("infoTributaria/dirMatriz"), normal),
        Spacer(1, 6),
        Paragraph(f"<b>FACTURA No. {numero_factura}</b>", normal),
        Paragraph(f"Fecha de emisión: {text('infoFactura/fechaEmision')}", normal),
        Paragraph(
            ("Ambiente: PRUEBAS" if comprobante.ambiente == 1 else "Ambiente: PRODUCCIÓN")
            + (
                f" · Autorización: {comprobante.numero_autorizacion}"
                if comprobante.numero_autorizacion
                else " · PENDIENTE DE AUTORIZACIÓN"
            ),
            normal,
        ),
        Spacer(1, 6),
        Paragraph(f"Cliente: {text('infoFactura/razonSocialComprador')}", normal),
        Paragraph(f"Identificación: {text('infoFactura/identificacionComprador')}", normal),
        Spacer(1, 10),
    ]

    rows = [["Cant.", "Descripción", "P. Unit.", "Total"]]
    for detalle in root.findall("detalles/detalle"):
        def dtext(tag: str, default: str = "") -> str:
            el = detalle.find(tag)
            return escape(el.text) if el is not None and el.text else default

        rows.append(
            [dtext("cantidad"), dtext("descripcion"), f"${dtext('precioUnitario', '0.00')}", f"${dtext('precioTotalSinImpuesto', '0.00')}"]
        )
    table = Table(rows, colWidths=[15 * mm, 90 * mm, 30 * mm, 30 * mm])
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#c45d35")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTSIZE", (0, 0), (-1, -1), 9),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#e5e7eb")),
                ("ALIGN", (2, 0), (-1, -1), "RIGHT"),
            ]
        )
    )
    elements.append(table)
    elements.append(Spacer(1, 10))
    elements.append(Paragraph(f"Subtotal: ${text('infoFactura/totalSinImpuestos', '0.00')}", normal))
    elements.append(Paragraph(f"<b>Total: ${text('infoFactura/importeTotal', '0.00')}</b>", normal))
    elements.append(Spacer(1, 10))

    barcode_buffer = BytesIO()
    code128 = barcode_lib.get("code128", clave_acceso, writer=ImageWriter())
    code128.write(barcode_buffer, options={"write_text": False, "module_height": 12.0})
    barcode_buffer.seek(0)
    elements.append(Image(barcode_buffer, width=150 * mm, height=20 * mm))
    elements.append(Paragraph(clave_acceso, small))

    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4, topMargin=15 * mm, bottomMargin=15 * mm, leftMargin=15 * mm, rightMargin=15 * mm)
    doc.build(elements)
    buffer.seek(0)
    return buffer


def sri_comprobante_by_order_ids(session: Session, order_ids: list[int]) -> dict[int, models.SriComprobante]:
    """Bulk lookup for embedding SRI invoice status in an order list — avoids N+1 per-row
    fetches (same pattern as branch_fulfillment.fulfillments_by_order_ids)."""
    if not order_ids:
        return {}
    rows = session.exec(
        select(models.SriComprobante).where(models.SriComprobante.order_id.in_(order_ids))
    ).all()
    return {r.order_id: r for r in rows}


MANUAL_INVOICE_PLACEHOLDER_NAME = "Línea personalizada (factura manual)"


def get_or_create_manual_line_placeholder(session: Session, tenant_id: int) -> models.Product:
    """Lazily creates the per-tenant placeholder Product that carries free-text manual-invoice
    lines. Never shown in product pickers (see the is_manual_invoice_placeholder filter on
    GET /products)."""
    existing = session.exec(
        select(models.Product).where(
            models.Product.tenant_id == tenant_id,
            models.Product.is_manual_invoice_placeholder == True,  # noqa: E712
        )
    ).first()
    if existing:
        return existing
    placeholder = models.Product(
        tenant_id=tenant_id,
        name=MANUAL_INVOICE_PLACEHOLDER_NAME,
        price_cents=0,
        is_manual_invoice_placeholder=True,
    )
    session.add(placeholder)
    session.commit()
    session.refresh(placeholder)
    return placeholder
