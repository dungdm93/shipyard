FROM python:3.8-slim AS base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.1 libisal2 libnss3 \
        libpq5 libmariadb3 \
        curl locales runit; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8;

ENV AIRFLOW_HOME="/opt/airflow"
RUN set -eux; \
    useradd -ms "/bin/bash" --uid=1000 airflow; \
    mkdir -p "${AIRFLOW_HOME}"; \
    chown -R airflow: "${AIRFLOW_HOME}";

WORKDIR ${AIRFLOW_HOME}

FROM base AS builder

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        build-essential \
        # pip install mysqlclient
        default-libmysqlclient-dev \
        # pip install sasl
        libsasl2-dev \
        # pip install pykerberos
        libkrb5-dev \
        # pip install python-snappy
        libsnappy-dev \
        libev-dev

ARG AIRFLOW_VERSION=2.0.1

RUN set -eux; \
    PYTHON_VERSION_SHORT="${PYTHON_VERSION%.*}"; \
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION_SHORT}.txt"; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    AIRFLOW_PACKAGES=( \
        # Core
        async cgroups redis rabbitmq \
        celery dask docker cncf.kubernetes \
        github_enterprise google_auth kerberos ldap password \
        # Database
        mysql postgres microsoft.mssql oracle mongo elasticsearch jdbc odbc \
        # Cloud Providers
        amazon microsoft.azure google \
        # BigData
        apache.cassandra apache.druid apache.pinot \
        presto \
        # Others
        crypto ssh grpc slack sendgrid \
        sentry statsd hashicorp \
    ); \
    pip install --constraint "${CONSTRAINT_URL}" \
        "apache-airflow[$(join ',' ${AIRFLOW_PACKAGES[@]})]==${AIRFLOW_VERSION}"; \
    pip install "lz4" "python-snappy" "sqlalchemy-trino";
        # "airflow-exporter==1.3.0"

FROM base

COPY ./scripts/* /usr/local/bin/
COPY --chown=airflow:airflow ./runit /etc/airflow
COPY --from=builder /usr/local/lib/python3.8/ /usr/local/lib/python3.8/

USER airflow
EXPOSE 8080 8793 5555
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
