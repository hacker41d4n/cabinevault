#!/bin/bash

set -e

clear

echo "=================================================="
echo "             CABINEVAULT INSTALLER"
echo "=================================================="
echo ""

# Update system

echo "[1/8] Updating package lists..."
sudo apt update

# Install Docker

echo "[2/8] Installing Docker..."

if ! command -v docker >/dev/null 2>&1; then
sudo apt install -y docker.io docker-compose
fi

sudo systemctl enable docker
sudo systemctl start docker

# Docker permissions

echo "[3/8] Configuring Docker permissions..."

sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

# Create folders

echo "[4/8] Creating directories..."

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

# Create env

echo "[5/8] Checking .env..."

if [ ! -f .env ] && [ -f .env.example ]; then
cp .env.example .env
fi

# Start containers

echo "[6/8] Starting CabineVault..."

sudo docker-compose pull
sudo docker-compose up -d

# Wait for services

echo "[7/8] Waiting for services..."
sleep 20

# Create SSH dashboard

echo "[8/8] Creating SSH dashboard..."

sudo tee /etc/profile.d/cabinevault.sh >/dev/null <<'EOF'
#!/bin/bash

if [ -n "$SSH_CONNECTION" ]; then


IP=$(hostname -I | awk '{print $1}')

echo ""
echo "======================================"
echo "          CABINEVAULT"
echo "======================================"
echo ""
echo "Server IP: $IP"
echo ""
echo "Portainer:           https://$IP:9443"
echo "Pi-hole:             http://$IP:8080/admin"
echo "Nginx Proxy Manager: http://$IP:81"
echo "Heimdall:            http://$IP:8083"
echo "n8n:                 http://$IP:5678"
echo "qBittorrent:         http://$IP:8081"
echo "pyLoad:              http://$IP:8000"
echo "Guacamole:           http://$IP:8082"
echo "Uptime Kuma:         http://$IP:3001"
echo ""
echo "Running Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"
echo ""


fi
EOF

sudo chmod +x /etc/profile.d/cabinevault.sh

SERVER_IP=$(hostname -I | awk '{print $1}')

QBIT_PASSWORD=$(sudo docker logs qbittorrent 2>&1 | grep -i "temporary password" | sed 's/.*temporary password is provided for this session: //')

echo ""
echo "=================================================="
echo "      CABINEVAULT INSTALLED SUCCESSFULLY"
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

if [ -n "$QBIT_PASSWORD" ]; then
echo "qBittorrent Username: admin"
echo "qBittorrent Password: $QBIT_PASSWORD"
echo ""
fi

echo "=================================================="
echo "CabineVault installation complete."
echo "=================================================="
