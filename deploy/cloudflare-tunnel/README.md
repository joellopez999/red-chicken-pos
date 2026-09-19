# Cloudflare Tunnel (reemplaza/complementa Tailscale Funnel)

Reemplaza el "TLS termina en Tailscale Funnel" por "TLS termina en la red de
Cloudflare", sin tocar HAProxy ni el resto del stack — sigue apuntando a
`http://localhost:8080` exactamente igual. Se hizo por un problema de
latencia real medido con Tailscale Funnel (~700-900ms de handshake TLS,
por el relay de Tailscale); con Cloudflare bajó a ~150-450ms, en parte
porque Cloudflare tiene un punto de presencia en Guayaquil (`gye01`).

Dominio: **pos.redchickenec.com** (comprado y administrado en Cloudflare).

## Cómo quedó instalado (2026-09-19)

1. `cloudflared` instalado desde el `.deb` oficial de GitHub releases (no hay
   paquete en los repos de Ubuntu).
2. `cloudflared tunnel login` — autoriza la cuenta de Cloudflare, guarda
   `~/.cloudflared/cert.pem`.
3. `cloudflared tunnel create red-chicken-pos` — crea el túnel con nombre,
   genera `~/.cloudflared/<TUNNEL_ID>.json` (la credencial real — **nunca
   subir esto a git**).
4. Config (`config.yml.example` en esta carpeta es la plantilla) copiado a
   `/etc/cloudflared/config.yml` **junto con** el `.json` de credenciales
   copiado a `/etc/cloudflared/` — el servicio corre como root y busca ahí,
   no en `~/.cloudflared` del usuario.
5. `cloudflared tunnel route dns red-chicken-pos pos.redchickenec.com` —
   crea el CNAME en Cloudflare.
6. `sudo cloudflared service install` — instala como servicio systemd
   (`/etc/systemd/system/cloudflared.service`), arranca solo, sobrevive
   reinicios.

## Verificar

```sh
systemctl status cloudflared
curl -o /dev/null -w "%{http_code} %{time_total}s\n" https://pos.redchickenec.com/
```

## Tailscale Funnel

Se dejó corriendo en paralelo como respaldo (no estorba, HAProxy sigue
escuchando en el mismo puerto para ambos). Si en algún momento se confirma
que Cloudflare es suficiente y se quiere apagar Tailscale Funnel:
`sudo tailscale funnel --https=443 off` (esto NO desconecta el tailnet
privado, solo el acceso público vía Funnel).

## Si hay que reinstalar en otra máquina

Los pasos 1-2 y 6 se repiten igual. Los pasos 3-5 (crear túnel/DNS) solo se
hacen una vez por túnel — si ya existe, solo hace falta copiar
`config.yml` + el `.json` de credenciales (pedirlo o regenerarlo con
`cloudflared tunnel create` de nuevo si se perdió) a `/etc/cloudflared/` en
la máquina nueva y correr `sudo cloudflared service install`.
