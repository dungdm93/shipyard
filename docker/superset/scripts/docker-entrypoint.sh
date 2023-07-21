#!/bin/bash
set -eo pipefail

case "$1" in
    webserver)
        superset-tools wait database
        superset db upgrade
        # https://docs.gunicorn.org/en/stable/settings.html
        if [ -n "$GUNICORN_CONFIG_PATH" ]; then
            GUNICORN_CMD_OPTS="--config=$GUNICORN_CONFIG_PATH ${GUNICORN_CMD_OPTS}"
        fi
        exec gunicorn --bind=0.0.0.0:8088 \
            ${GUNICORN_CMD_OPTS} \
            "superset.app:create_app()"
        ;;
    worker|beat|flower)
        superset-tools wait broker
        # https://superset.apache.org/docs/installation/async-queries-celery
        # https://docs.celeryproject.org/en/stable/userguide/configuration.html
        # https://docs.celeryproject.org/en/stable/reference/cli.html#celery-worker
        if [ -n "$CELERY_CONFIG_PATH" ]; then
            CELERY_CMD_OPTS="--config=$CELERY_CONFIG_PATH ${CELERY_CMD_OPTS}"
        fi
        exec celery \
            ${CELERY_CMD_OPTS} \
            "--app=superset.tasks.celery_app:app" \
            "$1" \
            ${CELERY_CMD_ARGS}
        ;;
    celery-ping)
        if [ -n "$CELERY_CONFIG_PATH" ]; then
            CELERY_CMD_OPTS="--config=$CELERY_CONFIG_PATH ${CELERY_CMD_OPTS}"
        fi
        exec celery \
            ${CELERY_CMD_OPTS} \
            "--app=superset.tasks.celery_app:app" \
            inspect ping -t 10 -d celery@$HOSTNAME
        ;;
    version)
        superset version
        ;;
    *)
        exec "$@"
        ;;
esac
