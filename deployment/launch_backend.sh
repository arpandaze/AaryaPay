#!/usr/bin/env bash

set -e

CONTAINER_NAME="backend-aaryapay"
CONFIG_PATH="/etc/staging.yaml"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Backend already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing backend container!"
    podman start $CONTAINER_NAME
    exit
fi

if [ -z "$CI_REGISTRY_IMAGE" ]; then
    CI_REGISTRY_IMAGE="registry.gitlab.com/teamaarya/aaryapay"
fi

echo "Creating new backend container!"

podman run \
  --name $CONTAINER_NAME \
  -e CONFIG=$CONFIG_PATH \
  -v $(pwd)/etc/staging.yaml:/etc/staging.yaml \
  -v $(pwd)/templates:/go/src/packages/goginapp/templates \
  -v $(pwd)/profile:/uploads \
  --network=host \
  -d $CI_REGISTRY_IMAGE/aaryapay-backend:latest
