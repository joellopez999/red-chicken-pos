-- Función #2 del módulo de teléfono con IA (ver ai_phone_menu_service.py): "explicar el
-- menú" — sin herramientas de pedido, sin crear Order, conversación acotada por tiempo y
-- número de turnos. Autenticado por token de dispositivo (no login de personal), porque
-- quien llama es un cliente que descolgó el teléfono, no un usuario del sistema.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'aiphonemenusessionstatus'
    ) THEN
        CREATE TYPE aiphonemenusessionstatus AS ENUM ('active', 'ended');
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS ai_phone_menu_device (
    id BIGSERIAL PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
    label VARCHAR(50) NOT NULL DEFAULT 'Teléfono 1',
    token_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    last_used_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS ix_ai_phone_menu_device_token_hash ON ai_phone_menu_device (token_hash);
CREATE INDEX IF NOT EXISTS ix_ai_phone_menu_device_tenant ON ai_phone_menu_device (tenant_id);

CREATE TABLE IF NOT EXISTS ai_phone_menu_session (
    id BIGSERIAL PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
    device_id INT NOT NULL REFERENCES ai_phone_menu_device(id) ON DELETE CASCADE,
    status aiphonemenusessionstatus NOT NULL DEFAULT 'active',
    turn_count INT NOT NULL DEFAULT 0,
    transcript JSONB,
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS ix_ai_phone_menu_session_tenant ON ai_phone_menu_session (tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_phone_menu_session_device ON ai_phone_menu_session (device_id);
CREATE INDEX IF NOT EXISTS ix_ai_phone_menu_session_status ON ai_phone_menu_session (status);
