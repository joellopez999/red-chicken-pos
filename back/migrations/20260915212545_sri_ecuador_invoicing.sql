-- Ecuador SRI electronic invoicing (comprobantes electrónicos).
-- Independent from VeriFactu (Spain) and TSE (Germany) fiscal fields already on tenant.

ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_mode VARCHAR(16) NOT NULL DEFAULT 'off';
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_ruc VARCHAR(13);
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_razon_social VARCHAR(300);
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_nombre_comercial VARCHAR(300);
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_direccion_matriz VARCHAR(300);
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_establecimiento VARCHAR(3) NOT NULL DEFAULT '001';
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_punto_emision VARCHAR(3) NOT NULL DEFAULT '001';
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_obligado_contabilidad BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_secuencial_factura INTEGER NOT NULL DEFAULT 1;
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_certificate_filename VARCHAR(255);
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS sri_certificate_password VARCHAR(512);

CREATE TABLE IF NOT EXISTS sri_comprobante (
    id SERIAL PRIMARY KEY,
    tenant_id INTEGER NOT NULL REFERENCES tenant(id),
    order_id INTEGER NOT NULL REFERENCES "order"(id),
    tipo_comprobante VARCHAR(2) NOT NULL DEFAULT '01',
    ambiente INTEGER NOT NULL DEFAULT 1,
    clave_acceso VARCHAR(49) NOT NULL,
    secuencial VARCHAR(9) NOT NULL,
    estado VARCHAR(16) NOT NULL DEFAULT 'PPR',
    xml_firmado TEXT NOT NULL DEFAULT '',
    xml_autorizado TEXT,
    numero_autorizacion VARCHAR(49),
    fecha_autorizacion TIMESTAMP WITH TIME ZONE,
    mensajes_error JSONB,
    amount_cents INTEGER NOT NULL DEFAULT 0,
    submitted_at TIMESTAMP WITH TIME ZONE,
    last_checked_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_sri_comprobante_clave_acceso UNIQUE (clave_acceso)
);

CREATE INDEX IF NOT EXISTS ix_sri_comprobante_tenant_id ON sri_comprobante (tenant_id);
CREATE INDEX IF NOT EXISTS ix_sri_comprobante_order_id ON sri_comprobante (order_id);
CREATE INDEX IF NOT EXISTS ix_sri_comprobante_estado ON sri_comprobante (estado);
