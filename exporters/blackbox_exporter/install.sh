set -euo pipefail
REPO=prometheus/blackbox_exporter
ARCH=linux-amd64
VER=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep -oP '"tag_name":\s*"v\K[^"]+')

cd /tmp
curl -fsSLO "https://github.com/${REPO}/releases/download/v${VER}/blackbox_exporter-${VER}.${ARCH}.tar.gz"
tar xzf "blackbox_exporter-${VER}.${ARCH}.tar.gz"
sudo install -m0755 "blackbox_exporter-${VER}.${ARCH}/blackbox_exporter" /usr/local/bin/
sudo mkdir -p /etc/blackbox_exporter
sudo useradd --system --no-create-home --shell /usr/sbin/nologin blackbox 2>/dev/null || true
