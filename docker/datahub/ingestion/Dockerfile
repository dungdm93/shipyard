FROM python:3.10-slim AS base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.* libisal2 libnss3 \
        libpq5 libmariadb3 libodbc1 \
        libldap-2.4-* libkrb5-3 \
        libsasl2-2 \
        libsasl2-modules-gssapi-mit \
        libsasl2-modules-ldap \
        libsasl2-modules-otp \
        libsasl2-modules-sql;

FROM base AS builder

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y \
        build-essential \
        # pip install mysqlclient
        default-libmysqlclient-dev \
        # pip install psycopg2
        libpq-dev \
        # pip install sasl
        libsasl2-dev \
        # pip install pykerberos
        libkrb5-dev \
        # pip install python-ldap
        libldap2-dev \
        # pip install python-snappy
        libsnappy-dev \
        # pip install pyodbc
        unixodbc-dev \
        libev-dev

ARG DATAHUB_VERSION=0.10.4.1

RUN --mount=type=cache,target=/root/.cache/pip \
    set -eux; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    DATAHUB_PACKAGES=( \
        # Sink plugins
        datahub-kafka datahub-rest datahub-lite \
        # Integrations (exclude airflow)
        circuit-breaker great-expectations \
        # Source plugins (exclude spark, delta-lake, s3, gcs, kafka-connect, unity-catalog (databricks))
        azure-ad ldap okta \
        athena glue redshift sagemaker bigquery \
        clickhouse clickhouse-usage dbt dbt-cloud hana salesforce snowflake vertica \
        looker lookml metabase mode redash superset tableau powerbi powerbi-report-server \
        hive iceberg presto trino starburst-trino-usage kafka pulsar druid nifi elasticsearch feast \
        sqlalchemy mongodb mssql mssql-odbc mysql mariadb oracle postgres \
    ); \
    pip install "acryl-datahub[$(join ',' ${DATAHUB_PACKAGES[@]})]==${DATAHUB_VERSION}"; \
    rm -rf /usr/local/cx_Oracle-doc;

FROM base

ENV DATAHUB_HOME="/opt/datahub"
RUN set -eux; \
    useradd -rms "/bin/bash" --uid=1000 datahub; \
    mkdir -p "${DATAHUB_HOME}"; \
    chown -R datahub: "${DATAHUB_HOME}";

USER datahub
WORKDIR ${DATAHUB_HOME}

COPY --from=builder /usr/local /usr/local
