# My Termux Widget Shortcuts

This repository contains custom scripts for the [Termux:Widget](https://github.com/termux/termux-widget) app.

## Shortcuts

### `start-awesome.sh`
This script starts the Awesome Window Manager inside a Debian proot-distro environment using Termux:X11. It calls `cleanup-x11.sh` automatically before starting.

### `cleanup-x11.sh`
A standalone "Panic" button to forcefully kill all X11, proot, and audio sessions. Use this if your display gets stuck or apps stop responding.

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
