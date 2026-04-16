# My Termux Widget Shortcuts

This repository contains custom scripts for the [Termux:Widget](https://github.com/termux/termux-widget) app.

## Shortcuts

### `start-awesome.sh`
This script starts the Awesome Window Manager inside a Debian proot-distro environment using Termux:X11.

**Key Features:**
- **Aggressive Cleanup:** Automatically kills previous X11, Xwayland, Pulseaudio, and proot sessions to prevent "Display already in use" errors.
- **Lock File Management:** Removes stale `.X1-lock` and socket files from `/usr/tmp/`.
- **Integrated Audio:** Starts Pulseaudio with network support for the proot environment.
- **Automatic Launch:** Opens the Termux:X11 Android application after starting the server.

## Installation

1. Install **Termux:Widget** from F-Droid.
2. Clone this repo into the `.shortcuts` folder:
   ```bash
   cd $HOME
   git clone https://github.com/arinadi/My-termux-widget.git .shortcuts
   chmod +x .shortcuts/*.sh
   ```
3. Add the Termux Widget to your home screen to see the shortcuts.

## Troubleshooting
If you encounter "Display already exists" errors even after running this script, the aggressive cleanup logic in `start-awesome.sh` is designed to handle this by purging the `/tmp` directory and killing any orphaned `termux-x11` processes.
