-- Registro manual de gastos operativos (módulo de Informes, botón "Registrar gasto").
-- Independiente de pedidos/productos — solo para contrastar contra las ventas ya
-- mostradas en Informes. Categoría es texto libre validado en la app, no un enum de
-- base de datos, para poder agregar categorías nuevas sin otra migración.

CREATE TABLE IF NOT EXISTS expense (
    id BIGSERIAL PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
    category VARCHAR(50) NOT NULL,
    amount_cents INT NOT NULL,
    description VARCHAR(500),
    expense_date DATE NOT NULL,
    created_by_user_id INT REFERENCES "user"(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_expense_tenant ON expense (tenant_id);
CREATE INDEX IF NOT EXISTS ix_expense_date ON expense (expense_date);
