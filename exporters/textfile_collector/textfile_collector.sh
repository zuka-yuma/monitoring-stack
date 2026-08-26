#!/bin/bash
set -euo pipefail

declare -A QUOTAS=(
  ["/mnt/storage/apps/nexus"]="${QUOTA_NEXUS_BYTES:-0}"
  ["/mnt/storage/incus"]="${QUOTA_INCUS_BYTES:-0}"
  ["/mnt/storage/netboot"]="${QUOTA_NETBOOT_BYTES:-0}"
)

OUT=/var/lib/node-exporter/textfile-collector/dirsize.prom.$$

for d in "${!QUOTAS[@]}"; do
  size=$(du -sb "$d" | cut -f1)
  echo "dir_size_bytes{path=\"$d\"} $size"
  echo "dir_quota_bytes{path=\"$d\"} ${QUOTAS[$d]}"
done > "$OUT"

upgrades=$(apt-get --just-print upgrade 2>/dev/null | grep -c '^Inst' || true)
security=$(apt-get --just-print upgrade 2>/dev/null | grep '^Inst' | grep -c -i 'security' || true)
reboot=0
[ -f /var/run/reboot-required ] && reboot=1

cat <<EOF >> "$OUT"
node_apt_upgrades_pending ${upgrades}
node_apt_security_upgrades_pending ${security}
node_reboot_required ${reboot}
EOF

mv "$OUT" /var/lib/node-exporter/textfile-collector/dirsize.prom
