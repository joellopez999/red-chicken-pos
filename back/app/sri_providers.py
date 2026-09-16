"""SOAP client for SRI's Recepción/Autorización comprobantes electrónicos web services.

WSDL endpoints and response schema confirmed live against the SRI's public WSDL
(2026-09-15) — not guessed from documentation alone.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from zeep import Client
from zeep.helpers import serialize_object

AMBIENTE_PRUEBAS = 1
AMBIENTE_PRODUCCION = 2

RECEPCION_WSDL = {
    AMBIENTE_PRUEBAS: "https://celcer.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl",
    AMBIENTE_PRODUCCION: "https://cel.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl",
}
AUTORIZACION_WSDL = {
    AMBIENTE_PRUEBAS: "https://celcer.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl",
    AMBIENTE_PRODUCCION: "https://cel.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl",
}


@dataclass
class RecepcionResult:
    estado: str  # RECIBIDA | DEVUELTA
    mensajes: list[dict[str, Any]] = field(default_factory=list)
    raw: dict[str, Any] = field(default_factory=dict)


@dataclass
class AutorizacionResult:
    estado: str | None  # AUT | NAT | PPR | None (no result yet)
    numero_autorizacion: str | None
    fecha_autorizacion: str | None
    comprobante_autorizado_xml: str | None
    mensajes: list[dict[str, Any]] = field(default_factory=list)
    raw: dict[str, Any] = field(default_factory=dict)


def _as_list(value: Any) -> list[dict[str, Any]]:
    if not value:
        return []
    return [value] if isinstance(value, dict) else list(value)


def enviar_recepcion(xml_firmado_bytes: bytes, ambiente: int) -> RecepcionResult:
    """POSTs the signed XML to Recepción. zeep base64-encodes raw bytes for xs:base64Binary.

    zeep auto-unwraps the single-field response wrapper (validarComprobanteResponse ->
    RespuestaRecepcionComprobante), so `response`/`data` is already the respuestaSolicitud
    object (confirmed live against the pruebas endpoint, not just the WSDL on paper).
    """
    client = Client(wsdl=RECEPCION_WSDL[ambiente])
    response = client.service.validarComprobante(xml=xml_firmado_bytes)
    data = serialize_object(response, dict) or {}
    estado = str(data.get("estado") or "")
    mensajes: list[dict[str, Any]] = []
    for comprobante in _as_list((data.get("comprobantes") or {}).get("comprobante")):
        mensajes.extend(_as_list((comprobante or {}).get("mensajes", {}).get("mensaje")))
    return RecepcionResult(estado=estado, mensajes=mensajes, raw=data)


def consultar_autorizacion(clave_acceso: str, ambiente: int) -> AutorizacionResult:
    """zeep auto-unwraps the response wrapper the same way as enviar_recepcion above."""
    client = Client(wsdl=AUTORIZACION_WSDL[ambiente])
    response = client.service.autorizacionComprobante(claveAccesoComprobante=clave_acceso)
    data = serialize_object(response, dict) or {}
    autorizaciones = _as_list((data.get("autorizaciones") or {}).get("autorizacion"))
    if not autorizaciones:
        return AutorizacionResult(None, None, None, None, [], data)
    # "si el comprobante fue no autorizado varias veces, el web service solamente
    # retornará el último estado" (Ficha Técnica §5.10) — last entry wins.
    latest = autorizaciones[-1] or {}
    mensajes = _as_list((latest.get("mensajes") or {}).get("mensaje"))
    fecha = latest.get("fechaAutorizacion")
    return AutorizacionResult(
        estado=latest.get("estado"),
        numero_autorizacion=latest.get("numeroAutorizacion"),
        fecha_autorizacion=str(fecha) if fecha else None,
        comprobante_autorizado_xml=latest.get("comprobante"),
        mensajes=mensajes,
        raw=data,
    )
