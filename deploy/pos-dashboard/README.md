# Panel local de control (pos-dashboard)

Panel de estado/control para uso solo en el servidor donde corre el POS. Sin
dependencias externas (solo stdlib de Python). Escucha en `127.0.0.1:8090`,
no está expuesto a la red ni a Tailscale Funnel.

Muestra: estado de los contenedores Docker, acceso Tailscale, disco,
estadísticas del negocio (con filtros por fecha y producto), y un log de
actuaciones del personal y errores del backend (con filtros por fecha, tipo
de acción y "solo errores"). Incluye botones para encender/apagar/reiniciar
el stack (`docker compose`).

## Instalación

1. Copiar `server.py`, `index.html` e `icon.png` a `/home/imac/pos-dashboard/`
   (la ruta está fija en `server.py` vía `REPO_DIR` y en el `.service`).
2. Instalar el servicio de usuario:
   ```sh
   mkdir -p ~/.config/systemd/user
   cp pos-dashboard.service ~/.config/systemd/user/
   systemctl --user daemon-reload
   systemctl --user enable --now pos-dashboard.service
   ```
3. `./pos-dashboard` abre el panel en el navegador (arranca el servicio si
   hace falta).

Tras editar `server.py`, reiniciar con `systemctl --user restart pos-dashboard.service`
para que tome los cambios (`index.html` se sirve leyendo el archivo en cada
request, sin necesidad de reiniciar).
