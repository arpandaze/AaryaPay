#!/usr/bin/env bash

set -x
set -eo pipefail

CONTAINER_NAME="mailpit-aaryapay-dev"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Mailpit already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing mailpit container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new mailpit container!"

podman run -d \
  --name=$CONTAINER_NAME \
  --restart unless-stopped \
  -e MP_SMTP_AUTH_ACCEPT_ANY=true \
  -e MP_SMTP_AUTH_ALLOW_INSECURE=true \
  -p 8025:8025 \
  -p 1025:1025 \
  docker.io/axllent/mailpit
