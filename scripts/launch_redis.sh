#!/usr/bin/env bash

REDIS_PASSWORD="${REDIS_PASSWORD:=redispass}"
CONTAINER_NAME="redis-aaryapay"

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Redis already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing redis container!"
    podman start $CONTAINER_NAME
    exit
fi

echo "Creating new redis container!"

podman run --name $CONTAINER_NAME \
  -h redis \
  -e REDIS_PASSWORD=$REDIS_PASSWORD \
  -p 6379:6379 \
  -d docker.io/library/redis:6-alpine /bin/sh -c 'redis-server --requirepass ${REDIS_PASSWORD}'
