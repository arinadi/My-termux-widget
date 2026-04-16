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

require_cmd proot-distro
require_cmd gzip
require_cmd sleep
require_cmd printf

BACKUP_FILE="${BACKUP_FILE:-$HOME/backup/debian-rootfs.tar.gz}"

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
    log "Error: Backup file failed gzip integrity check: $BACKUP_FILE"
    exit 1
fi

log "WARNING: This will DELETE your current Debian installation and replace it with the backup."
log "Press Ctrl+C now to cancel."
for i in $(seq 10 -1 1); do
    printf '[%s] Continuing in %d seconds...\r' "$SCRIPT_NAME" "$i"
    sleep 1
done
printf '\n'

CLEANUP_SCRIPT="$HOME/.shortcuts/cleanup-x11.sh"
if [ -x "$CLEANUP_SCRIPT" ]; then
    log "Stopping any running X11 sessions..."
    bash "$CLEANUP_SCRIPT"
else
    log "Note: cleanup script not found at $CLEANUP_SCRIPT, continuing anyway."
fi

if proot-distro list | grep -Eq '^\s*debian(\s|$)'; then
    log "Removing current Debian installation..."
    if ! proot-distro remove debian; then
        log "Error: Failed to remove current Debian installation. Aborting."
        exit 1
    fi
else
    log "Debian is not installed; skipping remove step."
fi

log "Restoring Debian from backup: $BACKUP_FILE"
if proot-distro restore "$BACKUP_FILE"; then
    log "Replace successful! Your Debian has been reverted to the backup state."
else
    log "Error: Replace failed during restoration after destructive removal."
    exit 1
fi
