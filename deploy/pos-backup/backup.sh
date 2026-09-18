#!/bin/bash
# Nightly backup for Red Chicken POS: dumps Postgres, uploads to Google Drive,
# and prunes old local copies. Runs via pos-backup.timer (systemd --user).
set -euo pipefail

BACKUP_DIR="/home/imac/pos-backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
FILENAME="redchicken_pos_${TIMESTAMP}.sql.gz"
LOCAL_PATH="${BACKUP_DIR}/${FILENAME}"
REMOTE="gdrive:RedChickenPOS-Backups"
LOCAL_RETENTION_DAYS=7

mkdir -p "$BACKUP_DIR"

docker exec pos-postgres pg_dump -U pos -d pos | gzip > "$LOCAL_PATH"

# A 0-byte or truncated dump must never silently "succeed" and overwrite good
# backups on Drive with garbage — better to fail loudly here.
if [ ! -s "$LOCAL_PATH" ]; then
    echo "ERROR: backup file is empty, aborting upload (pg_dump likely failed)" >&2
    rm -f "$LOCAL_PATH"
    exit 1
fi

rclone copy "$LOCAL_PATH" "$REMOTE" --quiet

# Drive keeps the long-term history; the local copy is just a staging buffer,
# so it doesn't need to accumulate forever on the same disk it's protecting against.
find "$BACKUP_DIR" -name "redchicken_pos_*.sql.gz" -mtime "+${LOCAL_RETENTION_DAYS}" -delete

echo "Backup completed: ${FILENAME} ($(du -h "$LOCAL_PATH" | cut -f1))"
