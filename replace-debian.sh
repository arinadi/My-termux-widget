#!/data/data/com.termux/files/usr/bin/bash

BACKUP_FILE="$HOME/backup/debian-rootfs.tar.gz"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found at $BACKUP_FILE"
    exit 1
fi

echo "WARNING: This will DELETE your current Debian installation and replace it with the backup."
echo "Press Ctrl+C now to cancel, or wait 5 seconds to continue..."
sleep 5

echo "Stopping any running sessions..."
bash $HOME/.shortcuts/cleanup-x11.sh

echo "Removing current Debian..."
proot-distro remove debian

echo "Restoring from backup..."
proot-distro restore "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Replace successful! Your Debian has been reverted to the backup state."
else
    echo "Replace failed during restoration!"
fi
