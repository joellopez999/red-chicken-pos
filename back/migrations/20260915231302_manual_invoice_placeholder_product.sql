-- Manual invoice (factura sin pedido) support: a per-tenant placeholder product carries
-- free-text line items (description + amount) on an OrderItem, since product_id is NOT NULL.

ALTER TABLE product
    ADD COLUMN IF NOT EXISTS is_manual_invoice_placeholder BOOLEAN NOT NULL DEFAULT FALSE;
