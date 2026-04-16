# My Termux Widget Shortcuts

Custom scripts for managing X11 sessions and Debian proot-distro via [Termux:Widget](https://github.com/termux/termux-widget).

## Requirements

- Termux app with access to `bash`
- `proot-distro`
- `termux-x11`
- `pulseaudio`
- `gzip`
- `df`, `pgrep`, `pkill`

## Desktop & X11 Shortcuts

### 🚀 `start-awesome.sh`
The main entry point for your desktop environment.
- Configurable via environment variables.
- Improved process detection using specific `pgrep` patterns to avoid false positives.
- Correctly identifies `termux-x11` via the `com.termux.x11.Loader` process.
- Verifies X11 socket creation and Awesome WM process after launch.
- Automatically launches the Termux:X11 app after successful startup.

### 🧹 `cleanup-x11.sh` (Linked to `~/cleanup-x11`)
A safer cleanup utility for X11 sessions.
- Targets the actual `com.termux.x11.Loader` process.
- Cleans up X11 lock and socket files for all displays to prevent "server already running" errors.
- Resets the `.X11-unix` directory with proper permissions.
- Safer process termination to avoid killing the active session.

---

## Backup & Maintenance Shortcuts

### 💾 `backup-debian.sh`
- Creates a timestamped compressed backup of your Debian proot-distro.
- Requires at least 2 GB of free space before starting.
- Validates the Debian distro is installed before backing up.
- Keeps previous backups instead of overwriting.

### 📥 `restore-debian.sh`
- Restores Debian from a backup archive.
- Accepts a positional backup file path argument.
- Validates existence, readability, size, and gzip integrity.
- Refuses to restore if Debian is already installed.

### 🔄 `replace-debian.sh`
- Validates backup gzip integrity before taking destructive action.
- Displays a 10-second countdown before removal.
- Skips removal if Debian is already absent.
- Warns clearly if restore fails after removal.

---

## Installation & Setup

1. Install **Termux:Widget** and required packages.
2. Clone this repo:
   ```bash
   git clone https://github.com/arinadi/My-termux-widget.git ~/.shortcuts
   chmod +x ~/.shortcuts/*.sh
   ```
3. Add the **Termux:Widget** to your Android home screen.

## Environment Variables

### `start-awesome.sh`
- `DISPLAY` — display to use (default `:1`)
- `DISTRO` — proot-distro name (default `debian`)
- `DEBIAN_USER` — Debian user to run Awesome WM as (default `admin`)
- `PULSE_PORT` — PulseAudio TCP port (default `4713`)

### `backup-debian.sh`
- `BACKUP_DIR` — backup destination directory (default `~/backup`)

## Changelog

- **2026-04-16**: 
  - Fixed false-positive process detection in `start-awesome.sh`.
  - Improved `cleanup-x11` to handle stale sockets and Loader processes more effectively.
  - Switched to more reliable `pgrep -x` for Awesome WM detection.
- Added strict shell mode: `set -euo pipefail` in all scripts.
- Added command dependency checks before execution.
- Standardized log prefix format for all scripts.
- Improved backup rotation and incomplete file cleanup.
- Added validation for restore and replace workflows.
- Added graceful X11 cleanup and startup verification.
