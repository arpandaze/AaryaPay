#!/usr/bin/env bash
set -x
set -eo pipefail

if [ "$(docker ps -q -f name=aarya_redis)" ]; then
    echo "Redis already running!"
    exit
fi

if [ "$(docker ps -aq -f name=aarya_redis)" ]; then
    echo "Launching existing redis container!"
    docker start aarya_redis
    exit
fi

echo "Creating new redis container!"

docker run --name aarya_redis \
  -h redis \
  -e REDIS_PASSWORD=redispass \
  -p 6379:6379 \
  -d redis:6-alpine /bin/sh -c 'redis-server --requirepass ${REDIS_PASSWORD}'
