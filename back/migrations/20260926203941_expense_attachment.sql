-- Adjunto opcional (foto o PDF del recibo/factura) en un gasto manual ("Registrar gasto").

ALTER TABLE expense ADD COLUMN IF NOT EXISTS attachment_filename VARCHAR(255);
ALTER TABLE expense ADD COLUMN IF NOT EXISTS attachment_content_type VARCHAR(100);
