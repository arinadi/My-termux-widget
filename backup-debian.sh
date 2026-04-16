#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME=$(basename "$0")

log() {
    printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        log "Error: required command '$1' is not installed or not in PATH."
        exit 1
    fi
}

BACKUP_DIR="${BACKUP_DIR:-$HOME/backup}"
BACKUP_BASE="$BACKUP_DIR/debian-rootfs"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_BASE-$TIMESTAMP.tar.gz"
INCOMPLETE_FILE="$BACKUP_FILE.incomplete"
MIN_FREE_BYTES=2147483648

require_cmd proot-distro
require_cmd df
require_cmd awk
require_cmd gzip

mkdir -p "$BACKUP_DIR"

FREE_KB=$(df -Pk "$BACKUP_DIR" | awk 'NR==2 {print $4}')
FREE_BYTES=$((FREE_KB * 1024))

if [ "$FREE_BYTES" -lt "$MIN_FREE_BYTES" ]; then
    log "Error: Not enough free space in $BACKUP_DIR. At least 2 GB is required."
    exit 1
fi

# Improved check: verify if the rootfs directory exists
if [ ! -d "/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian" ]; then
    log "Error: Debian rootfs directory not found. Please install it before running this backup."
    exit 1
fi

trap 'rm -f "$INCOMPLETE_FILE"' EXIT

log "Starting Debian backup..."
log "Destination: $BACKUP_FILE"
log "This may take several minutes depending on storage speed..."

proot-distro backup debian --output "$INCOMPLETE_FILE"

mv "$INCOMPLETE_FILE" "$BACKUP_FILE"
trap - EXIT

log "Backup successful!"
ls -lh "$BACKUP_FILE"
