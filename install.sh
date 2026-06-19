#!/bin/bash

set -e

clear

echo "=================================================="
echo "             CABINEVAULT INSTALLER"
echo "=================================================="
echo ""

echo "[1/7] Updating package lists..."
sudo apt update

echo "[2/7] Installing Docker..."

if ! command -v docker >/dev/null 2>&1; then
sudo apt install -y docker.io
fi

if ! command -v docker-compose >/dev/null 2>&1; then
sudo apt install -y docker-compose
fi

sudo systemctl enable docker
sudo systemctl start docker

echo "[3/7] Configuring Docker permissions..."

sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

echo "[4/7] Checking Pi-hole DNS requirements..."

if sudo ss -tulpn | grep -q ":53 "; then
if systemctl is-active --quiet systemd-resolved; then
echo "Disabling systemd-resolved for Pi-hole..."

    sudo systemctl stop systemd-resolved
    sudo systemctl disable systemd-resolved

    sudo rm -f /etc/resolv.conf
    echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf >/dev/null
fi

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

echo "[6/7] Checking .env..."

if [ ! -f .env ]; then
cp .env.example .env
fi

echo "[7/7] Starting CabineVault..."

if command -v docker-compose >/dev/null 2>&1; then
sudo docker-compose pull
sudo docker-compose up -d
else
sudo docker compose pull
sudo docker compose up -d
fi

sleep 15

SERVER_IP=$(hostname -I | awk '{print $1}')

QBIT_PASSWORD=$(sudo docker logs qbittorrent 2>&1 | grep -i "temporary password" | sed 's/.*temporary password is provided for this session: //')

echo ""
echo "=================================================="
echo "          CABINEVAULT INSTALLED SUCCESSFULLY"
echo "=================================================="
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

if [ -n "$QBIT_PASSWORD" ]; then
echo "qBittorrent Username: admin"
echo "qBittorrent Password: $QBIT_PASSWORD"
echo ""
fi

cat <<EOF | sudo tee /etc/profile.d/cabinevault.sh >/dev/null
#!/bin/bash

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "========== CABINEVAULT =========="
echo ""
echo "Portainer: https://$IP:9443"
echo "Pi-hole: http://$IP:8080/admin"
echo "NPM: http://$IP:81"
echo "n8n: http://$IP:5678"
echo "qBittorrent: http://$IP:8081"
echo "Uptime Kuma: http://$IP:3001"
echo ""
EOF

sudo chmod +x /etc/profile.d/cabinevault.sh

echo ""
echo "CabineVault installation complete."
echo ""
