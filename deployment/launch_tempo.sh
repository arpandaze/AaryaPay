#!/usr/bin/env bash

set -x
set -eo pipefail

CONTAINER_NAME="tempo-aaryapay"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Tempo already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing tempo container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new tempo container!"

podman run -d \
  --name=$CONTAINER_NAME \
  --restart unless-stopped \
  -v $(pwd)/etc/telemetry/tempo.yml:/etc/tempo.yml \
  -v $(pwd)/tempo:/tmp/tempo \
  -p 3200:3200 \
  -p 4317:4317 \
  docker.io/grafana/tempo \
  -config.file=/etc/tempo.yml
