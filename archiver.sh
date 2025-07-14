#!/bin/bash

# BASH LEARNING TASKS
# Task 11: Archive script to compress files and directories

set -euo pipefail
IFS=$'\n\t'

read -p "Enter the full path to the directory you want to backup: " SOURCE
DESTINATION="$HOME/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H%M)
DIR_NAME=$(basename "$SOURCE")
BACKUP_NAME="backup-$DIR_NAME-$TIMESTAMP.tar.gz"
MAX_BACKUPS=5

if [[ ! -d $SOURCE ]]; then
    echo "Source directory does not exist. Please provide a valid path."
    exit 1
fi

if [[ ! -d "$DESTINATION" ]]; then
    echo "Destination directory does not exist. Creating it..."
    mkdir -p "$DESTINATION"
fi

tar czf "$DESTINATION/$BACKUP_NAME" -C "$SOURCE" .
echo "Backup created: $DESTINATION/$BACKUP_NAME"

cd "$DESTINATION" || exit 1

backups=($(ls -1t backup-*.tar.gz))
for ((i=MAX_BACKUPS; i<${#backups[@]}; i++)); do
    echo "Removing old backup: ${backups[i]}"
    rm -f "${backups[i]}"
done