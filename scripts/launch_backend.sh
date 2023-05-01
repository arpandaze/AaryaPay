#!/usr/bin/env bash

CONTAINER_NAME="backend-aaryapay"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Backend already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing backend container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new backend container!"

podman run --name $CONTAINER_NAME -d $CI_REGISTRY_IMAGE/backend:latest
