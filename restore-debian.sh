#!/data/data/com.termux/files/usr/bin/bash

BACKUP_FILE="$HOME/backup/debian-rootfs.tar.gz"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found at $BACKUP_FILE"
    exit 1
fi

echo "Restoring Debian from backup..."
proot-distro restore "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Restore successful!"
else
    echo "Restore failed! (Note: Restore only works if the distro is not already installed)"
fi
