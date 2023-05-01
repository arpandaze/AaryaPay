#!/usr/bin/env bash

CONTAINER_NAME="file-server-aaryapay"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "File server already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing file server container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new file server container!"

podman run --name $CONTAINER_NAME -d $CI_REGISTRY_IMAGE/file-server:latest
