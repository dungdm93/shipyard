#!/bin/bash

if [ -z "$BACKUP_LOCATION" ]; then
  echo >&2 "BACKUP_LOCATION envvar is required"
  exit 1
fi

DBS=(
)

function backup() {
  local dbname=$1
  local time=$(date --iso-8601=seconds)

  ${POSTGRES_USERNAME:=postgres}
  ${POSTGRES_HOST:=localhost}
  ${POSTGRES_PORT:=5432}
  PG_OPTS=(
    --host="$POSTGRES_HOST"
    --port="$POSTGRES_PORT"
    --username="$POSTGRES_USERNAME"
  )
  if [ ! -z "$POSTGRES_PASSWORD" ]; then
    PG_OPTS+=(
        --password="$POSTGRES_PASSWORD"
    )
  fi

  echo "backup db=$dbname time=$time"
  pg_dump "${PG_OPTS[@]}" --dbname=$dbname --compress=9 |
  mc pipe "$BACKUP_LOCATION/$dbname/$time.gz";
}

for db in "${DBS[@]}"; do
  backup $db
done
