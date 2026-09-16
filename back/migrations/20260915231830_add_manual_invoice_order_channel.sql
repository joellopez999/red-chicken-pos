-- Manual invoice (factura sin pedido): new order_channel value.
ALTER TYPE orderchannel ADD VALUE IF NOT EXISTS 'manual_invoice';
