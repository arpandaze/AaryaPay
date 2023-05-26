#!/usr/bin/env bash

set -x
set -eo pipefail

CONTAINER_NAME="loki-aaryapay"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Loki already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing loki container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new loki container!"

podman run -d \
  --name=$CONTAINER_NAME \
  --restart unless-stopped \
  -p 3100:3100 \
  docker.io/grafana/loki
