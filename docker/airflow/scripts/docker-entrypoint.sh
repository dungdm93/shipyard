#!/bin/bash
set -eo pipefail

: ${NRETRY:=30}

wait_for() {
    local host=$1 port=$2

    local i=0
    while ! nc -z "$host" "$port" >/dev/null 2>&1; do
        ((i+=1))

        if [ $i -ge $NRETRY ]; then
            echo >&2 "[$(date -Iseconds)] $host:$port still not reachable, giving up"
            exit 1
        fi

        echo "[$(date -Iseconds)] waiting for $host:$port... $i/$NRETRY"
        sleep 3
    done
}

wait_for_database() {
    local DB_URL=$(airflow-tools get-config core sql_alchemy_conn)
    local DB_TYPE=$(airflow-tools parse-url "$DB_URL" --scheme)

    if [[ ! "$DB_TYPE" =~ *sqlite* ]]; then
        local DB_HOST=$(airflow-tools parse-url "$DB_URL" --host)
        local DB_PORT=$(airflow-tools parse-url "$DB_URL" --port)

        if [[ -z "$DB_PORT" ]]; then
            case $DB_TYPE in
                *mysql*)
                    DB_PORT=3306;;
                *postgresql*)
                    DB_PORT=5432;;
                *mssql*)
                    DB_PORT=1433;;
                *oracle*)
                    DB_PORT=1521;;
            esac
        fi

        wait_for $DB_HOST $DB_PORT
    fi
}

wait_for_celery_broker() {
    local BROKER_URL=$(airflow-tools get-config celery broker_url)

    local BROKER_TYPE=$(airflow-tools parse-url "$BROKER_URL" --scheme)
    local BROKER_HOST=$(airflow-tools parse-url "$BROKER_URL" --host)
    local BROKER_PORT=$(airflow-tools parse-url "$BROKER_URL" --port)

    if [[ -z "$BROKER_PORT" ]]; then
        case $BROKER_TYPE in
            *amqp*)
                BROKER_PORT=5672;;
            *redis*)
                BROKER_PORT=6379;;
        esac
    fi

    wait_for $BROKER_HOST $BROKER_PORT
}

migrate_db() {
    wait_for_database

    # TODO: disable examples while db migration in order to suppress some unexpected errors
    AIRFLOW__CORE__LOAD_EXAMPLES=False airflow upgradedb
}

run_daemon() {
    wait_for_database

    local EXECUTOR=$(airflow-tools get-config core executor)
    EXECUTOR="${EXECUTOR^^}"        # uppercase
    EXECUTOR="${EXECUTOR%EXECUTOR}" # remove EXECUTOR suffix

    if [ "$EXECUTOR" = "CELERY" ]; then
        # With the "Celery" executors, peform check broker_url
        wait_for_celery_broker
    fi

    exec airflow "$@"
}

run_aio() {
    wait_for_database

    ln -sfn /etc/airflow/webserver /etc/service/webserver
    ln -sfn /etc/airflow/scheduler /etc/service/scheduler

    local EXECUTOR=$(airflow-tools get-config core executor)
    EXECUTOR="${EXECUTOR^^}"        # uppercase
    EXECUTOR="${EXECUTOR%EXECUTOR}" # remove EXECUTOR suffix

    if [ "$EXECUTOR" = "CELERY" ]; then
        ln -sfn /etc/airflow/worker /etc/service/worker
        ln -sfn /etc/airflow/flower /etc/service/flower

        wait_for_celery_broker
    fi

    exec runsvdir -P /etc/service/
}

case "$1" in
    ""|aio)
        migrate_db
        run_aio
        ;;
    scheduler)
        migrate_db
        run_daemon "$@"
        ;;
    webserver|worker|flower)
        run_daemon "$@"
        ;;
    version)
        exec airflow "$@"
        ;;
    *)
        exec "$@"
        ;;
esac
