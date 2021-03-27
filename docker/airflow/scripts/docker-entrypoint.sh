#!/bin/bash
set -eo pipefail

case "$1" in
    scheduler)
        airflow-tools wait database
        AIRFLOW__CORE__LOAD_EXAMPLES=False airflow db upgrade
        exec airflow scheduler
        ;;
    webserver)
        airflow-tools wait database
        exec airflow webserver
        ;;
    celery)
        airflow-tools wait broker
        exec airflow "$@"
        ;;
    version)
        exec airflow version
        ;;
    *)
        exec "$@"
        ;;
esac
