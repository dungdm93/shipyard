#!/bin/bash
set -eo pipefail

if [ -n "$MINIO_CONFIG_CONTENT" ]; then
    mkdir -p $HOME/.mc
    echo "$MINIO_CONFIG_CONTENT" > $HOME/.mc/config.json
fi

exec "$@"
