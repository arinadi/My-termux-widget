#!/data/data/com.termux/files/usr/bin/bash

# Cleanup X11 aggressively
echo "Cleaning up X11 and previous sessions..."
pkill -9 -f "termux-x11" 2>/dev/null
pkill -9 -f "x11" 2>/dev/null
pkill -9 -f "Xwayland" 2>/dev/null
pkill -9 -f "proot-distro" 2>/dev/null
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "awesome" 2>/dev/null

# Remove lock files and sockets
rm -rf /data/data/com.termux/files/usr/tmp/.X*
rm -rf /data/data/com.termux/files/usr/tmp/.tX*
rm -rf /data/data/com.termux/files/usr/tmp/proot-*

echo "Cleanup complete."
