-- Módulo de toma de pedidos por teléfono con IA (ver ai_phone_order_service.py):
-- borrador de pedido armado en vivo por el modelo, que el personal debe aceptar
-- explícitamente antes de que se convierta en un Order real.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'aiphoneorderstatus'
    ) THEN
        CREATE TYPE aiphoneorderstatus AS ENUM ('in_progress', 'pending_review', 'accepted', 'rejected');
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS ai_phone_order (
    id BIGSERIAL PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
    phone_label VARCHAR(50) NOT NULL DEFAULT 'Teléfono 1',
    status aiphoneorderstatus NOT NULL DEFAULT 'in_progress',
    items JSONB,
    customer_note VARCHAR(500),
    transcript JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    accepted_by_user_id INT REFERENCES "user"(id),
    accepted_at TIMESTAMP,
    resulting_order_id INT REFERENCES "order"(id)
);

CREATE INDEX IF NOT EXISTS ix_ai_phone_order_tenant ON ai_phone_order (tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_phone_order_status ON ai_phone_order (status);

-- Nuevo canal de pedido: aceptado desde un borrador de IA telefónica.
ALTER TYPE orderchannel ADD VALUE IF NOT EXISTS 'ai_phone';
