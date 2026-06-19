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
sudo docker-compose stop

echo "Creating backup archive..."

sudo tar czf "$BACKUP_FILE" data .env compose.yaml

echo "Starting containers..."
sudo docker-compose start

echo ""
echo "======================================"
echo " BACKUP COMPLETED SUCCESSFULLY"
echo "======================================"
echo ""
echo "Backup File:"
echo "$BACKUP_FILE"
echo ""

sudo du -sh "$BACKUP_FILE"

echo ""
echo "======================================"
