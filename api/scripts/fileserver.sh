#!/usr/bin/env bash

set -x
set -eo pipefail

CONTAINER_NAME="file-server-aaryapay-dev"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "File server already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing file server container!"
    podman start $CONTAINER_NAME
    exit
fi

if [ -z "$CI_REGISTRY_IMAGE" ]; then
    CI_REGISTRY_IMAGE="registry.gitlab.com/teamaarya/aaryapay"
fi

echo "Creating new file server container!"

podman run --name $CONTAINER_NAME -p 8081:80 -v ../../.files/:/profile -d $CI_REGISTRY_IMAGE/aaryapay-file-server:latest
