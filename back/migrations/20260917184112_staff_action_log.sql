-- Unified log for staff actions (cancel/delete/mark-paid/issue-invoice/…) and unhandled
-- backend errors, surfaced with filters in the admin panel.
CREATE TABLE IF NOT EXISTS staff_action_log (
    id BIGSERIAL PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
    user_id INT REFERENCES "user"(id) ON DELETE SET NULL,
    user_email VARCHAR(255),
    action_type VARCHAR(64) NOT NULL,
    summary TEXT,
    detail JSONB,
    success BOOLEAN NOT NULL DEFAULT TRUE,
    error_message TEXT,
    request_path VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_staff_action_log_tenant_created
    ON staff_action_log (tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS ix_staff_action_log_tenant_action
    ON staff_action_log (tenant_id, action_type);
CREATE INDEX IF NOT EXISTS ix_staff_action_log_tenant_success
    ON staff_action_log (tenant_id, success);
