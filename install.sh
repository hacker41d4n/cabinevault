#!/bin/bash

set -e

clear

echo "=================================================="
echo "             CABINEVAULT INSTALLER"
echo "=================================================="
echo ""

echo "[1/9] Updating package lists..."
sudo apt update

echo "[2/9] Installing Docker..."

if ! command -v docker >/dev/null 2>&1; then
sudo apt install -y docker.io
fi

if ! command -v docker-compose >/dev/null 2>&1; then
sudo apt install -y docker-compose
fi

sudo systemctl enable docker
sudo systemctl start docker

echo "[3/9] Configuring Docker permissions..."

sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

echo "[4/9] Freeing port 53 for Pi-hole..."

if systemctl is-active --quiet systemd-resolved; then


echo "Stopping systemd-resolved..."

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved

sudo rm -f /etc/resolv.conf

cat <<EOF | sudo tee /etc/resolv.conf >/dev/null


nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

fi

echo "[5/9] Verifying port 53..."

if sudo ss -tulpn | grep -q ":53 "; then
echo ""
echo "ERROR: Port 53 is still in use."
echo ""
sudo ss -tulpn | grep ":53"
exit 1
fi

echo "[6/9] Creating directories..."

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

echo "[7/9] Checking .env..."

if [ ! -f .env ]; then


cat <<EOF > .env


TZ=Africa/Johannesburg
EOF


echo ".env created."


else


echo ".env already exists."


fi

echo "[8/9] Pulling containers..."

sudo docker-compose pull

echo "[9/9] Starting CabineVault..."

sudo docker-compose up -d

echo "Waiting for services..."
sleep 20

echo "Creating SSH dashboard..."

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
echo "Guacamole:           http://$IP:8082/guacamole"
echo "Uptime Kuma:         http://$IP:3001"
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
echo "Guacamole:           http://$SERVER_IP:8082/guacamole"
echo "Uptime Kuma:         http://$SERVER_IP:3001"
echo ""

if [ -n "$QBIT_PASSWORD" ]; then
echo "qBittorrent Username: admin"
echo "qBittorrent Password: $QBIT_PASSWORD"
echo ""
fi

echo "=================================================="
echo "Installation Complete"
echo "=================================================="
echo ""
echo "Reconnect SSH to see the CabineVault dashboard."
echo ""
