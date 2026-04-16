#!/data/data/com.termux/files/usr/bin/bash

# Define backup path
BACKUP_DIR="$HOME/backup"
BACKUP_FILE="$BACKUP_DIR/debian-rootfs.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "Starting backup of Debian proot-distro..."
echo "Destination: $BACKUP_FILE"
echo "This may take several minutes depending on your storage speed..."

# Run backup
proot-distro backup debian --output "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup successful!"
    ls -lh "$BACKUP_FILE"
else
    echo "Backup failed! Please check if you have enough storage space."
fi
