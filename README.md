# 🚀 CabineVault

### The Ultimate Self-Hosted Homelab Appliance

Transform any Ubuntu server into a powerful self-hosted platform in minutes.

CabineVault combines the most popular homelab services into a single easy-to-deploy stack powered by Docker and Docker Compose.

---

## ✨ Features

### 🛠 Infrastructure Management

* Portainer
* Docker Compose Integration

### 🌐 Network Services

* Pi-hole DNS Ad Blocking
* Nginx Proxy Manager
* SSL Certificate Management

### 🤖 Automation

* n8n Workflow Automation

### 📥 Downloads

* qBittorrent
* pyLoad

### 🖥 Remote Access

* Apache Guacamole
* RustDesk Server

### 📊 Monitoring

* Uptime Kuma

### 🏠 Dashboard

* Heimdall

---

# 📦 Included Services

| Service             | Description                 |
| ------------------- | --------------------------- |
| Portainer           | Docker Management           |
| Pi-hole             | Network-wide Ad Blocking    |
| Nginx Proxy Manager | Reverse Proxy & SSL         |
| Heimdall            | Service Dashboard           |
| n8n                 | Workflow Automation         |
| qBittorrent         | Torrent Client              |
| pyLoad              | Download Manager            |
| Guacamole           | Browser-based Remote Access |
| RustDesk            | Self-Hosted Remote Desktop  |
| Uptime Kuma         | Monitoring                  |

---

# 🖥 System Requirements

### Minimum

* 2 CPU Cores
* 4GB RAM
* 50GB Storage
* Ubuntu Server 24.04 LTS

### Recommended

* 4 CPU Cores
* 8GB RAM
* 100GB+ Storage
* SSD Storage
* Ubuntu Server 24.04 LTS

### Ideal

* Proxmox VM
* 4+ CPU Cores
* 16GB RAM
* 250GB SSD

---

# 🚀 Quick Installation

Clone the repository:

```bash
git clone https://github.com/hacker41d4n/cabinevault.git
cd cabinevault
```

Make the installer executable:

```bash
chmod +x install.sh
```

Run the installer:

```bash
./install.sh
```

CabineVault will automatically:

* Install Docker
* Install Docker Compose
* Create required folders
* Configure environment variables
* Pull latest container images
* Start all services

---

# ⚙ Configuration

Edit your environment variables:

```bash
nano .env
```

Example:

```env
TZ=Africa/Johannesburg
PUID=1000
PGID=1000

PIHOLE_PASSWORD=ChangeMe123

DOMAIN=example.com
ADMIN_EMAIL=admin@example.com
```

Restart after changes:

```bash
docker compose down
docker compose up -d
```

---

# 🌍 Accessing Services

Replace SERVER-IP with your server IP address.

| Service             | URL                         |
| ------------------- | --------------------------- |
| Portainer           | https://SERVER-IP:9443      |
| Pi-hole             | http://SERVER-IP:8080/admin |
| Nginx Proxy Manager | http://SERVER-IP:81         |
| Heimdall            | http://SERVER-IP:8083       |
| n8n                 | http://SERVER-IP:5678       |
| qBittorrent         | http://SERVER-IP:8081       |
| pyLoad              | http://SERVER-IP:8000       |
| Guacamole           | http://SERVER-IP:8082       |
| Uptime Kuma         | http://SERVER-IP:3001       |

---

# 💾 Backups

Create a backup:

```bash
chmod +x backup.sh
./backup.sh
```

Backups are stored in:

```text
./backups
```

Restore a backup:

```bash
chmod +x restore.sh
./restore.sh backups/backup-file.tar.gz
```

---

# 🔄 Updating CabineVault

Update containers:

```bash
docker compose pull
docker compose up -d
```

Update CabineVault:

```bash
git pull
docker compose pull
docker compose up -d
```

---

# 🔍 Troubleshooting

Check running containers:

```bash
docker ps
```

View logs:

```bash
docker logs container-name
```

Examples:

```bash
docker logs pihole
docker logs portainer
docker logs n8n
```

Restart all services:

```bash
docker compose restart
```

---

# 📁 Project Structure

```text
cabinevault/
├── compose.yaml
├── .env.example
├── install.sh
├── backup.sh
├── restore.sh
├── README.md
├── LICENSE
└── data/
```

---

# 🔐 Security Recommendations

* Change all default passwords
* Enable SSL certificates in Nginx Proxy Manager
* Restrict remote access using a VPN
* Keep containers updated
* Create regular backups

---


### CabineVault — Your Homelab. Simplified.
