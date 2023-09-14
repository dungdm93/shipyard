FROM python:3.10-slim AS base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl3 libisal2 libnss3 libsasl2-modules \
        libpq5 libmariadb3 libodbc1 \
        libldap-2.5-0 libkrb5-3 \
        curl locales;

RUN set -eux; \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8;

ENV AIRFLOW_HOME="/opt/airflow" \
    PATH="/home/airflow/.local/bin:$PATH"
RUN set -eux; \
    useradd -ms "/bin/bash" --uid=1000 airflow; \
    mkdir -p "${AIRFLOW_HOME}"; \
    chown -R airflow: "${AIRFLOW_HOME}";

WORKDIR ${AIRFLOW_HOME}

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

ARG AIRFLOW_VERSION=2.6.2 \
    ASTRONOMER_PROVIDERS_VERSION=1.17.1 \
    ASTRONOMER_COSMOS_VERSION=0.7.4 \
    DATAHUB_REST_EMITTER_VERSION=0.11.0

RUN --mount=type=cache,target=/root/.cache/pip \
    set -eux; \
    PYTHON_VERSION_SHORT="${PYTHON_VERSION%.*}"; \
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION_SHORT}.txt"; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    AIRFLOW_PACKAGES=( \
        # Core
        http ftp ssh grpc microsoft.psrp \
        async cgroups redis rabbitmq leveldb \
        celery dask pandas docker cncf.kubernetes \
        github_enterprise google_auth kerberos ldap password \
        # Database
        sqlite mysql postgres microsoft.mssql oracle \
        mongo elasticsearch neo4j \
        jdbc odbc \
        # BigData
        apache.beam apache.cassandra apache.drill apache.druid apache.flink apache.hdfs \
        apache.hive apache.impala apache.kafka apache.kylin apache.pig apache.pinot apache.sqoop \
        presto trino \
        # Cloud Providers
        alibaba amazon microsoft.azure google github \
        # Cloud Services
        airbyte databricks snowflake tableau vertica \
        yandex facebook zendesk salesforce \
        # Others
        crypto slack sendgrid telegram \
        sentry statsd hashicorp otel \
    ); \
    pip install --constraint "${CONSTRAINT_URL}" \
        "apache-airflow[$(join ',' ${AIRFLOW_PACKAGES[@]})]==${AIRFLOW_VERSION}"; \
    pip install "astronomer-providers[$(join ',' ${AIRFLOW_PACKAGES[@]})]==${ASTRONOMER_PROVIDERS_VERSION}"; \
    pip install "astronomer-cosmos[dbt-all]==${ASTRONOMER_COSMOS_VERSION}"; \
    pip install "acryl-datahub[datahub-rest]==${DATAHUB_REST_EMITTER_VERSION}";

RUN --mount=type=cache,target=/root/.cache/pip \
    set -eux; \
    pip install "lz4" "python-snappy"; \
    rm -rf /usr/local/bin/__pycache__

FROM base

COPY --from=builder /usr/local /usr/local
COPY --link ./scripts/ /usr/local/bin/

USER airflow
EXPOSE 8080 8793 5555
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
