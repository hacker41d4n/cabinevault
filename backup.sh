#!/bin/bash

set -e

BACKUP_DIR="./backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/cabinevault-$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "======================================"
echo "      CABINEVAULT BACKUP UTILITY"
echo "======================================"
echo ""

echo "Stopping containers..."
docker compose stop

echo "Creating backup archive..."
tar -czf "$BACKUP_FILE" 
data 
.env 
compose.yaml

echo "Starting containers..."
docker compose start

echo ""
echo "Backup completed successfully!"
echo ""
echo "Backup file:"
echo "$BACKUP_FILE"
echo ""
echo "======================================"
