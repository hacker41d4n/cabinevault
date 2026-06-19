#!/bin/bash

set -e

if [ -z "$1" ]; then
echo ""
echo "Usage:"
echo "./restore.sh <backup-file.tar.gz>"
echo ""
exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
echo "Backup file not found!"
exit 1
fi

echo "======================================"
echo "      CABINEVAULT RESTORE UTILITY"
echo "======================================"
echo ""

echo "Stopping containers..."
docker compose down

echo "Removing existing data..."
rm -rf data

echo "Restoring backup..."
tar -xzf "$BACKUP_FILE"

echo "Starting containers..."
docker compose up -d

echo ""
echo "Restore completed successfully!"
echo ""
echo "======================================"
