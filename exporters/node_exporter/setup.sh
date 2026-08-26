sudo mkdir -p /etc/systemd/system/node_exporter.service.d
sudo tee /etc/systemd/system/node_exporter.service.d/override.conf > /dev/null <<'EOF'
[Service]
# ExecStart は一度空にしないと追記になってしまう
ExecStart=
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=0.0.0.0:9100 \
  --collector.systemd \
  --collector.systemd.unit-include=^(sshd|nginx|chrony|systemd-timesyncd|slapd|named|postfix|docker|containerd|rsyslog|prometheus|grafana-server)\.service$ \
  --collector.processes \
  --collector.textfile.directory=/var/lib/node_exporter/textfile_collector \
  --collector.ethtool \
  --collector.filesystem.mount-points-exclude=^/(dev|proc|sys|run|var/lib/docker/.+|var/lib/containers/.+)($|/) \
  --collector.filesystem.fs-types-exclude=^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$
EOF

sudo mkdir -p /var/lib/node_exporter/textfile_collector
sudo chown -R node_exporter: /var/lib/node_exporter 2>/dev/null || true

sudo systemctl daemon-reload
sudo systemctl restart node_exporter
