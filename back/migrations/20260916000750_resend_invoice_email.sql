-- Send the authorized SRI invoice (RIDE + XML) to the customer's email via Resend.
ALTER TABLE tenant
    ADD COLUMN IF NOT EXISTS resend_api_key VARCHAR(255);
ALTER TABLE sri_comprobante
    ADD COLUMN IF NOT EXISTS email_sent_at TIMESTAMP WITH TIME ZONE;
