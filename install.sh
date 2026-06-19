#!/bin/bash

set -e

clear

echo "=================================================="
echo "             CABINEVAULT INSTALLER"
echo "=================================================="
echo ""

# Check for root

if [ "$EUID" -eq 0 ]; then
echo "Please do not run this script as root."
echo "Run it as a normal user with sudo access."
exit 1
fi

echo "[1/7] Updating package lists..."
sudo apt update

echo "[2/7] Installing required packages..."
sudo apt install -y 
curl 
wget 
git 
ca-certificates 
gnupg 
lsb-release

# Install Docker if missing

if ! command -v docker >/dev/null 2>&1; then
echo "[3/7] Installing Docker..."
curl -fsSL https://get.docker.com | sudo sh

```
sudo usermod -aG docker $USER

echo ""
echo "Docker installed."
echo "You may need to log out and back in after installation."
echo ""
```

else
echo "[3/7] Docker already installed."
fi

# Install Docker Compose plugin if missing

if ! docker compose version >/dev/null 2>&1; then
echo "[4/7] Installing Docker Compose..."
sudo apt install -y docker-compose-plugin
else
echo "[4/7] Docker Compose already installed."
fi

echo "[5/7] Creating folders..."

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

if [ ! -f .env ]; then
echo "[6/7] Creating .env file..."
cp .env.example .env
else
echo "[6/7] Existing .env detected."
fi

echo "[7/7] Starting CabineVault..."

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
echo "Portainer:            https://$SERVER_IP:9443"
echo "Pi-hole:              http://$SERVER_IP:8080/admin"
echo "Nginx Proxy Manager:  http://$SERVER_IP:81"
echo "Heimdall:             http://$SERVER_IP:8083"
echo "n8n:                  http://$SERVER_IP:5678"
echo "qBittorrent:          http://$SERVER_IP:8081"
echo "pyLoad:               http://$SERVER_IP:8000"
echo "Guacamole:            http://$SERVER_IP:8082"
echo "Uptime Kuma:          http://$SERVER_IP:3001"
echo ""
echo "To view containers:"
echo "docker ps"
echo ""
echo "To update:"
echo "docker compose pull && docker compose up -d"
echo ""
echo "Enjoy CabineVault!"
echo "=================================================="
