#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME=$(basename "$0")
DISPLAY_NAME="${DISPLAY:-:1}"
DISPLAY_NUM="${DISPLAY_NAME##*:}"
DISTRO="${DISTRO:-debian}"
DEBIAN_USER="${DEBIAN_USER:-admin}"
PULSE_PORT="${PULSE_PORT:-4713}"
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
require_cmd termux-x11
require_cmd pulseaudio
require_cmd proot-distro
require_cmd am
require_cmd sleep
require_cmd rm

SOCKET_FILE="$TMP_DIR/.X11-unix/X${DISPLAY_NUM}"
LOCK_FILE="$TMP_DIR/.X${DISPLAY_NUM}-lock"

if pgrep -f "com.termux.x11.Loader.*${DISPLAY_NAME}" >/dev/null 2>&1; then
    log "Session already running on $DISPLAY_NAME. Connecting..."
else
    log "Starting new session on display $DISPLAY_NAME..."

    rm -f "$LOCK_FILE" "$SOCKET_FILE" 2>/dev/null || true

    termux-x11 "$DISPLAY_NAME" -ac &
    sleep 2

    if ! pgrep -x "pulseaudio" >/dev/null 2>&1; then
        log "Starting PulseAudio..."
        pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 >/dev/null 2>&1 || true
    fi

    # Check for awesome process
    if ! pgrep -x "awesome" >/dev/null 2>&1; then
        log "Starting Awesome WM..."
        LOG_FILE="$TMP_DIR/awesome-start.log"
        proot-distro login "$DISTRO" --user "$DEBIAN_USER" --shared-tmp -- bash -lc \
            "export DISPLAY='$DISPLAY_NAME' PULSE_SERVER='tcp:127.0.0.1:$PULSE_PORT' && exec awesome" \
            >"$LOG_FILE" 2>&1 &
        
        sleep 3
        if ! pgrep -x "awesome" >/dev/null 2>&1; then
            log "Error: Awesome WM did not start. Check $LOG_FILE for details."
        else
            log "Awesome WM started successfully."
        fi
    else
        log "Awesome WM is already running."
    fi
fi

log "Launching Termux:X11 app..."
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1 || true
