#!/usr/bin/env bash

CONTAINER_NAME="proxy-aaryapay"
CONFIG_PATH="./etc/proxy"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Proxy already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing proxy container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new proxy container!"

podman run -d \
  --network host \
  -v $CONFIG_PATH:/etc/traefik \
  -v acme.json:/acme.json \
  --name $CONTAINER_NAME \
  docker.io/library/traefik:v2.5 \
  --log.level=INFO \
  --configfile=/etc/traefik/traefik.yml
