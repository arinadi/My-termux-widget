#!/data/data/com.termux/files/usr/bin/bash

# Run cleanup script
bash $HOME/.shortcuts/cleanup-x11.sh

# Start termux-x11
echo "Starting termux-x11..."
termux-x11 :1 -ac &
sleep 3

# Start Audio
echo "Starting Audio..."
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 2>/dev/null

# Start Awesome WM in Debian
echo "Starting Awesome WM..."
proot-distro login debian --user admin --shared-tmp -- env DISPLAY=:1 PULSE_SERVER=tcp:127.0.0.1:4713 awesome &
sleep 2

# Launch the X11 app
echo "Launching Termux:X11 app..."
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
