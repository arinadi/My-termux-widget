#!/data/data/com.termux/files/usr/bin/bash

# Check if termux-x11 is already running on display :1
if pgrep -f "termux-x11 :1" > /dev/null; then
    echo "Session already running. Connecting..."
else
    echo "Starting new session..."
    # Only remove stale lock files, don't kill other processes
    rm -f /data/data/com.termux/files/usr/tmp/.X1-lock
    rm -f /data/data/com.termux/files/usr/tmp/.X11-unix/X1
    
    # Start termux-x11
    termux-x11 :1 -ac &
    sleep 3

    # Start Audio if not running
    if ! pgrep -x "pulseaudio" > /dev/null; then
        echo "Starting Audio..."
        pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 2>/dev/null
    fi

    # Start Awesome WM if not running
    if ! pgrep -f "awesome" > /dev/null; then
        echo "Starting Awesome WM..."
        proot-distro login debian --user admin --shared-tmp -- env DISPLAY=:1 PULSE_SERVER=tcp:127.0.0.1:4713 awesome &
        sleep 2
    fi
fi

# Always ensure the X11 app is in front
echo "Launching Termux:X11 app..."
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
