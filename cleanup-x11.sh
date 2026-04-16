#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME=$(basename "$0")
DISPLAY_NAME="${1:-:1}"
DISPLAY_NUM="${DISPLAY_NAME##*:}"
TMP_DIR="/data/data/com.termux/files/usr/tmp"

log() {
    printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        log "Error: required command '$1' is not installed or not in PATH."
        exit 1
    fi
}

require_cmd pgrep
require_cmd pkill
require_cmd sleep
require_cmd rm

log "Cleaning up X11 and previous sessions on display $DISPLAY_NAME..."

for pattern in "termux-x11.*$DISPLAY_NAME" "x11" "Xwayland" "proot-distro" "pulseaudio" "awesome"; do
    if pgrep -f "$pattern" >/dev/null 2>&1; then
        pkill -15 -f "$pattern" 2>/dev/null || true
    fi
done

sleep 1

for pattern in "termux-x11.*$DISPLAY_NAME" "x11" "Xwayland" "proot-distro" "pulseaudio" "awesome"; do
    if pgrep -f "$pattern" >/dev/null 2>&1; then
        pkill -9 -f "$pattern" 2>/dev/null || true
    fi
done

rm -rf "$TMP_DIR/.X${DISPLAY_NUM}-lock" "$TMP_DIR/.X11-unix/X${DISPLAY_NUM}" "$TMP_DIR/.X*" "$TMP_DIR/.tX*" "$TMP_DIR/proot-*" 2>/dev/null || true

log "Cleanup complete."
