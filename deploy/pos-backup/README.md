# Respaldo automático de la base de datos

Respaldo diario de Postgres (pg_dump comprimido) subido a Google Drive vía
`rclone`, con retención local de 7 días (Drive conserva el historial completo).
Corre como timer de systemd de usuario, la misma cuenta que corre
`pos-dashboard.service`.

## Instalación en una máquina nueva

1. Instalar rclone: `sudo apt-get install -y rclone`
2. Configurar el remoto de Google Drive: `rclone config` (nombre del remoto:
   `gdrive`, tipo: Google Drive, `client_id`/`client_secret`/`root_folder_id`
   vacíos, scope `1`, auto config `y` — abre el navegador para autorizar la
   cuenta). El archivo resultante (`~/.config/rclone/rclone.conf`) contiene un
   token de acceso real — **nunca se sube a git**.
3. Crear la carpeta en Drive: `rclone mkdir gdrive:RedChickenPOS-Backups`
4. Copiar `backup.sh` a `/home/imac/pos-backup/backup.sh` y darle permiso de
   ejecución (`chmod +x`).
5. Copiar `pos-backup.service` y `pos-backup.timer` a
   `~/.config/systemd/user/`.
6. Habilitar "linger" para que corra sin sesión iniciada:
   `sudo loginctl enable-linger <usuario>`.
7. `systemctl --user daemon-reload && systemctl --user enable --now pos-backup.timer`

## Verificar

- Ejecutar una vez a mano: `systemctl --user start pos-backup.service`
- Ver el resultado: `journalctl --user -u pos-backup.service -n 20`
- Ver la próxima ejecución programada: `systemctl --user list-timers pos-backup.timer`
- Confirmar que llegó a Drive: `rclone ls gdrive:RedChickenPOS-Backups`

## Restaurar un respaldo (prueba real hecha el 2026-09-18)

```sh
gunzip -c redchicken_pos_YYYYMMDD_HHMMSS.sql.gz \
  | docker exec -i pos-postgres psql -U pos -d <base_destino> -v ON_ERROR_STOP=1
```
