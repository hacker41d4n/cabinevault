#!/bin/bash

set -e

if [ -z "$1" ]; then
echo "Usage:"
echo "./restore.sh <backup-file>"
exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
echo "Backup file not found."
exit 1
fi

echo "======================================"
echo "      CABINEVAULT RESTORE UTILITY"
echo "======================================"
echo ""

echo "Stopping containers..."
sudo docker-compose down

echo "Removing old data..."
sudo rm -rf data

echo "Restoring backup..."
sudo tar -xzf "$BACKUP_FILE"

echo "Starting containers..."
sudo docker-compose up -d

echo ""
echo "Restore completed successfully!"
echo ""
echo "======================================"
