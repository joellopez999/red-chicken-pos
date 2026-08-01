# Despliegue de RED CHICKEN POS en la máquina de producción

Sistema: POS web basado en Satisfecho POS (AGPL-3.0), personalizado para **Red Chicken**
(marca, arreglos de UI móvil, estación de cocina, menú cargado).

Esta máquina de desarrollo (Mac) NO es la de producción. Estos pasos reproducen el
sistema en la **máquina definitiva** (Linux/Mac con Docker).

---

## 1. Requisitos en la máquina de producción
- **Docker** + **Docker Compose** instalados y corriendo.
- Git.
- Estar en la misma red local que la(s) máquina(s) de cocina/caja.

## 2. Clonar el proyecto
```bash
git clone https://github.com/joellopez999/red-chicken-pos.git
cd red-chicken-pos
```

## 3. Crear la configuración (con secretos NUEVOS)
```bash
cp config.env.example config.env
```
Edita `config.env` y **cambia los secretos** (no reutilices los de desarrollo):
- `SECRET_KEY`, `REFRESH_SECRET_KEY` → cadenas largas y aleatorias
- `POSTGRES_PASSWORD` / `DB_PASSWORD` → una contraseña fuerte (la misma en ambos)
- Deja `CORS_ORIGINS=*` y `API_URL=/api` (funcionan en cualquier IP)
- `SAAS_PAYWALL_ENABLED=false`, `STRIPE_CURRENCY=usd`

Genera un secreto rápido:
```bash
openssl rand -hex 32
```

**Importante (por un ajuste del compose):** copia también el config dentro de `back/`:
```bash
cp config.env back/config.env
```

## 4. Levantar el sistema
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file config.env up -d --build
```
Espera a que compile (unos minutos la primera vez). Verifica:
```bash
curl -s http://localhost:4202/api/health   # -> {"status":"ok"}
```

## 5. Cargar los datos (menú, categorías, estación de cocina, moneda USD)
El respaldo está en `deploy/seed.sql`. Restáuralo en la base:
```bash
docker exec -i pos-postgres psql -U pos -d pos < deploy/seed.sql
```
Esto deja el menú RED CHICKEN, el nivel de picante, la estación "Cocina",
la moneda USD y la cuenta de dueño ya configurados.

> Si prefieres empezar de cero: **NO** restaures el seed; entra a `/register`,
> crea tu cuenta, y carga el menú con "Importación masiva" (JSON en `deploy/menu.json`).

## 6. Acceder
- Caja / gestión: `http://<IP-de-esta-maquina>:4202`
- Pantalla de cocina (otra máquina, solo navegador): `http://<IP-de-esta-maquina>:4202/kitchen`
- Averigua la IP: `hostname -I` (Linux) o `ipconfig getifaddr en0` (Mac)

## 7. Que arranque solo (opcional pero recomendado en producción)
Los contenedores tienen `restart: unless-stopped`, así que reinician con Docker.
Solo asegúrate de que **Docker arranque al encender la máquina** (Docker Desktop:
Settings → General → "Start Docker Desktop when you log in"; en Linux: `systemctl enable docker`).

---

## Notas
- Corre en **modo desarrollo** (ng serve). Para una red local funciona bien.
  Para producción "real" con HTTPS/dominio existe `docker-compose.prod.yml` (requiere certificados).
- **Actualizar el código** en el futuro: en producción `git pull` y `docker compose ... up -d --build`.
- **Licencia**: el proyecto es AGPL-3.0. Conserva los avisos de licencia (archivo `LICENSE`).
  Puedes usarlo y modificarlo libremente; solo si lo ofreces como servicio por red a terceros
  debes poner el código a disposición de esos usuarios (nunca tus datos).
- Personalizaciones aplicadas: marca "Red Chicken", arreglos de teclado/scroll en móvil,
  estación de cocina, páginas de marketing del proveedor ocultas.
