#!/bin/bash
for d in /mnt/storage/apps/nexus /mnt/storage/incus /mnt/storage/netboot; do
  size=$(du -sb "$d" | cut -f1)
  echo "dir_size_bytes{path=\"$d\"} $size"
done > /var/lib/node_exporter/textfile_collector/dirsize.prom.$$ \
  && mv /var/lib/node_exporter/textfile_collector/dirsize.prom.$$ \
        /var/lib/node_exporter/textfile_collector/dirsize.prom
