#!/bin/bash
set -euo pipefail
METRICS_DIR=/var/lib/node_exporter/textfile_collector
if restic backup /home /etc /mnt/ssd \
  --exclude=/mnt/ssd/restic \
  --exclude=/mnt/ssd/swapfile \
  --exclude=/mnt/ssd/prometheus \
	&& restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune; then
  echo "restic_backup_last_success_timestamp_seconds $(date +%s)" \
    > "$METRICS_DIR/restic_backup.prom.$$"
  mv "$METRICS_DIR/restic_backup.prom.$$" "$METRICS_DIR/restic_backup.prom"
fi
