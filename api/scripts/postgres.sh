#!/usr/bin/env bash
set -x
set -eo pipefail


DB_USER="${POSTGRES_USER:=postadmin}"
DB_PASSWORD="${POSTGRES_PASSWORD:=postpass}"
DB_NAME="${POSTGRES_DB:=aaryapay}"
DB_PORT="${POSTGRES_PORT:=5432}"


if [ "$(docker ps -q -f name=aaryapay_postgres)" ]; then
    echo "Postgres already running!"
    exit
fi

if [ "$(docker ps -aq -f name=aaryapay_postgres)" ]; then
    echo "Launching existing postgres container!"
    docker start aaryapay_postgres 
else
    echo "Creating new postgres container!"
    docker run --name aaryapay_postgres \
      -e POSTGRES_USER=${DB_USER} \
      -e POSTGRES_PASSWORD=${DB_PASSWORD} \
      -e POSTGRES_DB=${DB_NAME} \
      -p "${DB_PORT}":5432 \
      -d postgres:13-alpine \
      postgres -N 1000
fi

# Keep pinging Postgres until it's ready to accept commands
until PGPASSWORD="${DB_PASSWORD}" psql -h "localhost" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
  >&2 echo "Postgres is still unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up and running on port ${DB_PORT}!"

DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}?sslmode=disable

migrate -source file://migrations -database=$DATABASE_URL up
