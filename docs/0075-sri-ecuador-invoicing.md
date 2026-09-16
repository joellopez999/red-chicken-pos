# SRI electronic invoicing (Ecuador)

## Purpose

Electronic factura issuance for Ecuador tenants (Red Chicken) via the SRI's (Servicio de Rentas Internas) `comprobantes electrónicos` scheme: tenant `sri_mode`, XAdES-BES XML signing, SOAP submission (Recepción/Autorización), and RIDE (printed representation) generation.

Independent from VeriFactu (`docs/0018-verifactu-fiscal-invoicing.md`) and TSE (`docs/0072-tse-fiscal-compliance.md`) — a **new** country-specific pipeline, not a plug-in to either of those (their `fiscal_providers.py`/`tse_providers.py` abstraction only covers the HTTP-submission step for an already Spain/Germany-shaped payload; SRI's document semantics — XML schema, access-key algorithm, XAdES structure, SOAP contract — have no shared code with them).

## Disclaimer

- `sri_mode: pruebas` submits to the SRI's **testing** environment (`celcer.sri.gob.ec`) — per the SRI's own ficha técnica, documents authorized there **have no legal or tax validity**.
- Switching to `sri_mode: produccion` requires the tenant to have **requested production certification themselves** via the SRI's own web portal (`www.sri.gob.ec` → Servicios en línea) — this is a manual administrative step, not something this codebase automates.
- IVA is applied at **0%** (`CODIGO_PORCENTAJE_IVA_0` in `sri_invoice_service.py`) per the tenant's confirmed tax regime as of 2026-09-16. This is a business/legal decision, not a technical default — do not change to another rate without confirming the *current* SRI `codigoPorcentaje` code for that rate (the codes have changed across ficha técnica versions).

## Official technical reference

Confirmed against the SRI's "Ficha Técnica: Emisión de Comprobantes Electrónicos" and live against the real pruebas WSDL (2026-09-15):

- WSDL pruebas: `https://celcer.sri.gob.ec/comprobantes-electronicos-ws/{RecepcionComprobantesOffline,AutorizacionComprobantesOffline}?wsdl`
- WSDL producción: same paths under `https://cel.sri.gob.ec/`
- Clave de acceso: 49 digits (fecha ddmmaaaa + tipoComprobante + RUC + ambiente + estab+ptoEmi + secuencial + código numérico + tipoEmisión + dígito verificador módulo 11, factor 2..7 cycling from the right).
- Firma: XAdES-BES, enveloped, RSA-SHA1, SHA1 digests, `.p12` certificate — built manually in `sri_signing.py` to match the SRI's own Anexo 8 reference structure exactly (no SignaturePolicyIdentifier — that's XAdES-EPES, not BES).

## Data model

`Tenant`: `sri_mode` (off/pruebas/produccion), `sri_ruc`, `sri_razon_social`, `sri_nombre_comercial`, `sri_direccion_matriz`, `sri_establecimiento`, `sri_punto_emision`, `sri_obligado_contabilidad`, `sri_secuencial_factura`, `sri_certificate_filename`, `sri_certificate_password` (masked in every settings response, like `stripe_secret_key`).

`SriComprobante` (table `sri_comprobante`): one row per order's factura attempt — `clave_acceso` (unique), `secuencial`, `estado` (PPR/RECIBIDA/DEVUELTA/AUT/NAT), `xml_firmado`, `xml_autorizado`, `numero_autorizacion`, `fecha_autorizacion`, `mensajes_error` (SRI's own rejection messages, JSONB).

## Modules

- `sri_invoice_service.py` — `generar_clave_acceso` (módulo 11), `generar_xml_factura` (Anexo 1 schema), `generar_ride_pdf` (reportlab + Code128 barcode of the clave de acceso).
- `sri_signing.py` — `load_p12`, `sign_factura_xml` (manual XAdES-BES construction via `lxml`, not a generic library — see file docstring for why).
- `sri_providers.py` — `enviar_recepcion`, `consultar_autorizacion` (SOAP via `zeep`). Note: zeep auto-unwraps the single-field response wrapper — `data` from `serialize_object` is already the `respuestaSolicitud`/`respuestaComprobante` object, not nested under `RespuestaRecepcionComprobante`/`RespuestaAutorizacionComprobante` as the WSDL's literal XSD would suggest.
- `sri_authorization_worker.py` — asyncio loop (same pattern as `reservation_reminder_heartbeat.py`/`social_publish_worker.py`, registered in `main.py`'s `_app_lifespan`) polling Autorización every 20s for comprobantes still `PPR`/`RECIBIDA`.

## Endpoints

- `POST /tenant/sri/certificate` (multipart: file + password) — stores under `uploads/{tenant_id}/sri/`, blocked from public static serving (`deny_public_sri_certificate_uploads`), password never returned.
- `POST /orders/{order_id}/sri-invoice/issue` — idempotent per order; generates, signs, submits Recepción; the sequential counter only advances on `RECIBIDA` (a `DEVUELTA` malformed attempt doesn't burn a número).
- `GET /orders/{order_id}/sri-invoice` — poll until `estado` is `AUT`/`NAT`.
- `GET /orders/{order_id}/sri-invoice/ride` — PDF, available once submitted (marked PENDIENTE before authorization).

Frontend: `front/src/app/orders/orders.component.ts` (`issueSriInvoiceForEditOrder`, polls every 2s up to 15 attempts, opens the RIDE on `AUT`), Settings page has the config fields + certificate upload (`front/src/app/settings/settings.component.ts`).

## Testing done (2026-09-15/16)

- `back/tests/test_sri_invoice_service.py`: módulo-11 check digit matches the ficha técnica's own worked example; XAdES-BES signature independently re-verified with the certificate's public key (proves the RSA-SHA1 + C14N round-trip, not just "the code ran").
- Live smoke tests against the real pruebas SOAP endpoints (not mocked): a garbage XML correctly got `DEVUELTA`/error 35; a full `generar_xml_factura` output for a real order **passed schema validation** and was only rejected for `FECHA EMISIÓN EXTEMPORANEA` — expected, since this dev environment's clock is set to a simulated date; `consultar_autorizacion` against a malformed clave correctly returned error 80. All test data (orders, tenant fields) was cleaned up after.
- Full existing pytest suite: 436 passed, 5 pre-existing failures unrelated to this change (SQLite-only test fixtures choking on an unrelated pre-existing JSONB column, `tip_preset_percents` — reproducible without any SRI code).

## Not yet exercised

Nothing here has been submitted with a **real** SRI-issued certificate — that requires the tenant's actual `.p12` (which they have) and their real RUC/razón social entered in Settings. The schema/signature/SOAP plumbing is verified; the remaining unknown is purely "does SRI trust *this* certificate's issuing CA and *this* RUC's authorization for electronic invoicing" — which can only be confirmed once real credentials are used.

## Explicitly out of scope

Notas de crédito/débito, guías de remisión, comprobantes de retención (factura, tipo "01", only). Batch/lote submission. Automatic email delivery to the receptor. Production cutover (tenant's own SRI portal action).
