#!/bin/bash

set -e

echo "=================================================="
echo "             CABINEVAULT INSTALLER"
echo "=================================================="
echo ""

echo "[1/5] Updating package lists..."
sudo apt update

echo "[2/5] Checking Docker..."

if ! command -v docker >/dev/null 2>&1; then
echo "Docker not found. Installing..."

```
sudo apt install -y docker.io docker-compose-v2

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

echo ""
echo "Docker installed successfully."
```

else
echo "Docker already installed."
fi

echo "[3/5] Creating folders..."

mkdir -p data/portainer
mkdir -p data/pihole/etc-pihole
mkdir -p data/pihole/etc-dnsmasq.d
mkdir -p data/npm/data
mkdir -p data/npm/letsencrypt
mkdir -p data/heimdall
mkdir -p data/n8n
mkdir -p data/qbittorrent/config
mkdir -p data/pyload
mkdir -p data/rustdesk
mkdir -p data/uptime-kuma
mkdir -p data/downloads
mkdir -p backups

echo "[4/5] Checking .env..."

if [ ! -f .env ]; then
cp .env.example .env
echo ".env created."
else
echo ".env already exists."
fi

echo "[5/5] Starting CabineVault..."

docker compose pull
docker compose up -d

SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================================="
echo "          CABINEVAULT INSTALLED SUCCESSFULLY"
echo "=================================================="
echo ""
echo "Server IP: $SERVER_IP"
echo ""
echo "Portainer:           https://$SERVER_IP:9443"
echo "Pi-hole:             http://$SERVER_IP:8080/admin"
echo "Nginx Proxy Manager: http://$SERVER_IP:81"
echo "Heimdall:            http://$SERVER_IP:8083"
echo "n8n:                 http://$SERVER_IP:5678"
echo "qBittorrent:         http://$SERVER_IP:8081"
echo "pyLoad:              http://$SERVER_IP:8000"
echo "Guacamole:           http://$SERVER_IP:8082"
echo "Uptime Kuma:         http://$SERVER_IP:3001"
echo ""
echo "Run 'docker ps' to view running containers."
echo ""
