#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo ".env が見つかりません。.env.example をコピーして値を埋めてください" >&2
  exit 1
fi

set -a
source .env
set +a

envsubst < prometheus/prometheus.yml.template > prometheus/prometheus.yml
envsubst < alertmanager/alertmanager.yml.template > alertmanager/alertmanager.yml

echo "生成しました: prometheus/prometheus.yml, alertmanager/alertmanager.yml"
