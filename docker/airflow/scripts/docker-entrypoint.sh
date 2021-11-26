#!/bin/bash
set -eo pipefail

if [ "$#" == "0" ]; then
    echo "Missing an airflow component (standalone, scheduler, webserver, triggerer, worker, flower)"
    echo "        or a custom command."
    echo "==================== airflow --help ===================="
    airflow --help

	exit 1
fi

component="$1"
shift

case "$component" in
    standalone)
        airflow-tools wait database
        AIRFLOW__CORE__LOAD_EXAMPLES=False airflow db upgrade
        exec airflow standalone "$@"
        ;;
    scheduler)
        airflow-tools wait database
        AIRFLOW__CORE__LOAD_EXAMPLES=False airflow db upgrade
        exec airflow scheduler "$@"
        ;;
    webserver)
        airflow-tools wait database
        exec airflow webserver "$@"
        ;;
    triggerer)
        airflow-tools wait broker
        exec airflow triggerer "$@"
        ;;
    worker)
        airflow-tools wait broker
        exec airflow celery worker "$@"
        ;;
    flower)
        airflow-tools wait broker
        exec airflow celery flower "$@"
        ;;
    celery)
        airflow-tools wait broker
        exec airflow celery "$@"
        ;;
    version)
        exec airflow version
        ;;
    *)
        exec $component "$@"
        ;;
esac
