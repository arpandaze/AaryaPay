#!/usr/bin/env bash

DB_USER="${POSTGRES_USER:=postadmin}"
DB_PASSWORD="${POSTGRES_PASSWORD:=postpass}"
CONTAINER_NAME="postgres-aaryapay"
DB_NAME="${POSTGRES_DB:=aaryapay}"
DB_PORT="${POSTGRES_PORT:=5432}"
DATA_DIR="./postgresql/data/pgdata"

mkdir -p $DATA_DIR

if [ "$(podman ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Postgres already running!"
    exit
fi

if [ "$(podman ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Launching existing postgres container!"
    podman start $CONTAINER_NAME 
else
    echo "Creating new postgres container!"
    podman run --name $CONTAINER_NAME \
      -e POSTGRES_USER=${DB_USER} \
      -e POSTGRES_PASSWORD=${DB_PASSWORD} \
      -e POSTGRES_DB=${DB_NAME} \
      -v $DATA_DIR:/var/lib/postgresql/data \
      -p "${DB_PORT}":5432 \
      -d docker.io/library/postgres:13-alpine \
      postgres -N 1000
fi

# Keep pinging Postgres until it's ready to accept commands
until PGPASSWORD="${DB_PASSWORD}" psql -h "localhost" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
  >&2 echo "Postgres is still unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up and running on port ${DB_PORT}!"
