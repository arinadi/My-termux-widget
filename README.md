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
- Verifies X11 socket creation after startup.
- Verifies Awesome WM process after launch.
- Warns if PulseAudio fails but still continues.

### 🧹 `cleanup-x11.sh`
A safer cleanup utility for X11 sessions.
- Sends `SIGTERM` first, waits 1 second, then sends `SIGKILL`.
- Supports an optional display argument (`$1`, default `:1`).
- Removes stale lock files and socket files.

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

- Added strict shell mode: `set -euo pipefail` in all scripts.
- Added command dependency checks before execution.
- Standardized log prefix format for all scripts.
- Improved backup rotation and incomplete file cleanup.
- Added validation for restore and replace workflows.
- Added graceful X11 cleanup and startup verification.
