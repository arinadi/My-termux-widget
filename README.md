# My Termux Widget Shortcuts

Custom scripts for managing X11 sessions and Debian proot-distro via [Termux:Widget](https://github.com/termux/termux-widget).

## Desktop & X11 Shortcuts

### 🚀 `start-awesome.sh`
The main entry point for your desktop environment.
- **Smart Attach:** Checks if a `termux-x11` session is already running. If found, it simply brings the window to the front without restarting anything (safe to click anytime).
- **Auto-Start:** If no session exists, it cleans stale lock files, starts the X11 server, Pulseaudio, and Awesome WM inside Debian.

### 🧹 `cleanup-x11.sh`
The "Panic Button" for X11 issues.
- Forcefully kills `termux-x11`, `Xwayland`, `proot-distro`, `pulseaudio`, and `awesome`.
- Cleans up all temporary socket and lock files to resolve "Display already in use" errors.

---

## Backup & Maintenance Shortcuts
*Backups are stored in `~/backup/debian-rootfs.tar.gz`.*

### 💾 `backup-debian.sh`
- Creates a full compressed backup of your current Debian proot-distro.
- Ideal for manual uploads to cloud storage like Google Drive.

### 📥 `restore-debian.sh`
- Installs the Debian distro from your local backup file.
- **Note:** Only works if the `debian` distro is not currently installed.

### 🔄 `replace-debian.sh`
- **Dangerous:** Deletes your current Debian installation and replaces it with the version from your backup.
- Use this as a "Factory Reset" to revert your environment to a known good state.

---

## Installation & Setup

1. Install **Termux:Widget** app.
2. Ensure this repo is cloned to the correct location:
   ```bash
   git clone https://github.com/arinadi/My-termux-widget.git ~/.shortcuts
   chmod +x ~/.shortcuts/*.sh
   ```
3. Long-press on your Android home screen and add the **Termux:Widget** to access these shortcuts.
