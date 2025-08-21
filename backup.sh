#!/bin/bash
# Backup Windows Server Shares to Linux
# Author: Shady

# ========== Configuration ==========
WIN_SERVER="192.168.213.20"      # IP of Windows Server
SHARE_NAME="it-folder"              # The name of the shared folder in Windows
USERNAME="it-user1"              # Windows username
PASSWORD="shady@123"             # Windows password
MOUNT_POINT="/mnt/winshare"      # Temporary mount point on Linux
BACKUP_DIR="/srv/it_backup"      # Where backups will be stored on Linux
LOG_FILE="/var/log/win_backup.log"

# ========== Script ==========
echo "===== Starting Windows Backup =====" | tee -a "$LOG_FILE"
date | tee -a "$LOG_FILE"

# 1. Create mount point if not exists
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
fi

# 2. Mount Windows share
sudo mount -t cifs "//$WIN_SERVER/$SHARE_NAME" "$MOUNT_POINT" -o username=$USERNAME,password=$PASSWORD,vers=3.0 || {
    echo " Failed to mount Windows share" | tee -a "$LOG_FILE"
    exit 1
}

# 3. Create backup folder with date
TODAY=$(date +%F_%H-%M-%S)
DEST="$BACKUP_DIR/win_backup_$TODAY"
mkdir -p "$DEST"

# 4. Copy files
rsync -av --delete "$MOUNT_POINT/" "$DEST/" >> "$LOG_FILE" 2>&1

# 5. Unmount share
sudo umount "$MOUNT_POINT"

# 6. Log completion
echo " Backup completed successfully!" | tee -a "$LOG_FILE"
echo "Files are saved in: $DEST" | tee -a "$LOG_FILE"

