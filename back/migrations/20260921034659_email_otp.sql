-- 2FA alternativo: código de 6 dígitos por correo (Resend) en vez de app autenticadora.
-- Sin secreto persistente — el código de cada intento de login viaja dentro del JWT
-- otp_pending de corta duración (ver security.py / main.py).

ALTER TABLE "user" ADD COLUMN IF NOT EXISTS email_otp_enabled BOOLEAN NOT NULL DEFAULT FALSE;
