#!/bin/bash

function get_props {
    grep -v "^\s*[#!]" "${1}" | grep "${2}" | cut -d'=' -f2
}

CATALOG_DIR=/etc/trino/catalog
for CATALOG_FILE in $CATALOG_DIR/*; do
    CACHE_DIR=$(get_props "$CATALOG_FILE" "hive.cache.location")
    if [ -n "$CACHE_DIR" ]; then
        mkdir -p "$CACHE_DIR";
    fi;
done
