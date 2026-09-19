# Panel local de control (pos-dashboard)

Panel de estado/control para uso solo en el servidor donde corre el POS. Sin
dependencias externas (solo stdlib de Python). Escucha en `127.0.0.1:8090`,
no está expuesto a la red ni a Tailscale Funnel.

Muestra: estado de los contenedores Docker, acceso Tailscale, disco,
recursos del sistema (CPU/RAM/energía, en vivo e histórico por rango de
1h/6h/24h/7 días), estadísticas del negocio (con filtros por fecha y
producto), y un log de actuaciones del personal y errores del backend (con
filtros por fecha, tipo de acción y "solo errores"). Incluye botones para
encender/apagar/reiniciar el stack (`docker compose`).

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

## Frontend: build de producción, no `ng serve`

`COMPOSE_BASE` incluye `docker-compose.front-prod.yml` (raíz del repo) para
que los botones de encender/reiniciar levanten el frontend como build
compilado (nginx) en vez del servidor de desarrollo de Angular. **No** usar
`docker-compose.prod.yml` directamente en este despliegue — ese archivo
también reemplaza HAProxy por `haproxy.prod.cfg` con certificados de
certbot para los puertos 80/443, pensado para un dominio público propio, no
para este esquema con Tailscale Funnel. Ver el comentario al inicio de
`docker-compose.front-prod.yml` para más detalle.

## Recursos del sistema: CPU, RAM y energía

CPU y RAM se leen directo de `/proc` (sin dependencias). El historial se
guarda en `metrics.db` (SQLite, junto a `server.py`, no se sube a git),
muestreado cada 60s en un hilo de fondo, con 30 días de retención.

**Energía**: usa el contador de hardware Intel RAPL (`/sys/class/powercap/`),
que mide el consumo real del procesador — **no** el consumo total de la
máquina (pantalla, disco, ventiladores quedan fuera). Solo funciona en CPUs
Intel con soporte RAPL. El archivo del contador es de solo lectura para
root por defecto; para habilitarlo:

```sh
sudo tee /etc/udev/rules.d/99-rapl-readable.rules > /dev/null <<'EOF'
SUBSYSTEM=="powercap", KERNEL=="intel-rapl:*", RUN+="/bin/chmod a+r /sys%p/energy_uj"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger -s powercap
```

Sin este paso, el panel sigue funcionando normalmente — la tarjeta de
energía simplemente muestra "No disponible" en vez de vatios.

## Estimado de costo eléctrico

La tarifa usada es una variable explícita en `server.py`
(`ELECTRICITY_PRICE_USD_PER_KWH`), con la fórmula documentada al lado en
`ENERGY_COST_FORMULA` — ambas se devuelven también en la respuesta de
`/api/metrics/history` y se muestran en el panel, para que la tarifa y el
cálculo nunca queden escondidos.

Valor actual: **$0.10/kWh** — tarifa residencial promedio de Ecuador para
2026 (subsidiada; el costo real de provisión es ~$0.1061/kWh), según
ARCONEL. [Fuente](https://www.eluniverso.com/noticias/economia/tarifa-electrica-ecuador-2026-arconel-servicio-basico-nota/).
Si ARCONEL ajusta la tarifa, se actualiza solo esa constante.

Importante: el estimado usa el consumo del procesador (RAPL), no el de la
máquina completa — es una cota inferior real, no el gasto eléctrico total
del equipo.

### Estimado de la máquina completa

Además del estimado de solo-CPU, el panel muestra un segundo estimado para
la iMac completa, combinando lo que sí medimos (CPU en vivo) con el consumo
total real medido y publicado para este modelo exacto (iMac 21.5" Late 2015,
i5 1.6GHz = iMac16,1): **33W en reposo, 58W a máxima carga**
([fuente](https://www.tpcdb.com/product.php?id=2525)).

Fórmula (constantes `IMAC_IDLE_TOTAL_WATTS`/`IMAC_MAX_TOTAL_WATTS` en
`server.py`):
```
base_no_cpu   = promedio(33W, 58W) − CPU_promedio_medido
total_estimado = base_no_cpu + CPU_medido_ahora
```
Sigue siendo una estimación, no una medición — un enchufe inteligente entre
la iMac y la pared es la única forma de tener el consumo total exacto.

### Ajuste por pantalla apagada

GNOME apaga la pantalla a los 900s de inactividad en este equipo
(`org.gnome.desktop.session idle-delay`) — el sistema sigue corriendo, solo
se apaga el panel. Como la referencia de fábrica (33W/58W) se midió con la
pantalla encendida, el panel detecta el estado real vía `systemd-logind`
(`loginctl show-session ... -p IdleHint`) y le resta al estimado un ahorro
asumido de `SCREEN_OFF_SAVINGS_WATTS = 15W` (retroiluminación LED típica de
21.5", no una cifra medida) proporcional al % de tiempo que la pantalla
estuvo apagada en el rango seleccionado.
