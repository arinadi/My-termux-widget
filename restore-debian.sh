#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME=$(basename "$0")

log() {
    printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

usage() {
    cat <<EOF
Usage: $0 <backup-file>
Restore a Debian proot-distro from a compressed backup archive.

Arguments:
  <backup-file>  Path to the .tar.gz backup file.
EOF
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        log "Error: required command '$1' is not installed or not in PATH."
        exit 1
    fi
}

require_cmd proot-distro
require_cmd gzip

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    log "Error: Backup file not found at $BACKUP_FILE"
    exit 1
fi

if [ ! -r "$BACKUP_FILE" ]; then
    log "Error: Backup file is not readable: $BACKUP_FILE"
    exit 1
fi

if [ ! -s "$BACKUP_FILE" ]; then
    log "Error: Backup file is empty: $BACKUP_FILE"
    exit 1
fi

if ! gzip -t "$BACKUP_FILE" >/dev/null 2>&1; then
    log "Error: Backup file is not a valid gzip archive: $BACKUP_FILE"
    exit 1
fi

if proot-distro list | grep -Eq '^\s*debian(\s|$)'; then
    log "Error: Debian distro is already installed. Remove it before restoring to avoid conflicts."
    exit 1
fi

log "Restoring Debian from backup: $BACKUP_FILE"
proot-distro restore "$BACKUP_FILE"

log "Restore successful!"
