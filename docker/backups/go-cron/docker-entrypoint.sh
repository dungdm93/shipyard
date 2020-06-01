#!/bin/bash
set -ex

if [ -z "$SCHEDULE" ]; then
    echo >&2 "SCHEDULE envvar is required"
    exit 1
fi

EXTRA_OPS=()

if [ ! -z "$PORT" ]; then
    EXTRA_OPS+=("-p" "$PORT")
fi

exec go-cron -s "$SCHEDULE" "${EXTRA_OPS[@]}" -- "$@"
