#!/usr/bin/env bash

set -x
set -eo pipefail

CONTAINER_NAME="grafana-aaryapay"
DATA_DIR="./grafana"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Grafana already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing grafana container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new grafana container!"

podman run -d \
  --name=$CONTAINER_NAME \
  --restart unless-stopped \
  -v $DATA_DIR:/var/lib/grafana \
  --network=host \
  docker.io/grafana/grafana-oss:latest
