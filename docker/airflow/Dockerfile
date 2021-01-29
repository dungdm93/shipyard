FROM python:3.7-slim AS base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl runit rsync netcat locales \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.1 libisal2 libnss3 \
        libpq5 libmariadb3; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8;

ENV AIRFLOW_HOME="/opt/airflow" \
    PATH=/home/airflow/.local/bin:$PATH
RUN set -eux; \
    useradd -ms "/bin/bash" --uid=1000 airflow; \
    mkdir -p "${AIRFLOW_HOME}"; \
    chown -R airflow: "${AIRFLOW_HOME}";

WORKDIR ${AIRFLOW_HOME}

FROM base AS builder

ARG AIRFLOW_VERSION=1.10.12

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

USER airflow

RUN set -eux; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    AIRFLOW_PACKAGES=( \
        # Executor
        celery dask docker kubernetes \
        # Database
        mysql postgres mongo jdbc \
        # Celery Broker
        redis rabbitmq \
        # Authentication
        password ldap kerberos google_auth github_enterprise \
        # Cloud Providers
        aws azure gcp \
        # BigData
        hdfs hive presto \
        # Others
        async crypto ssh slack sendgrid \
    ); \
    pip config set global.user True; \
    pip install \
        "apache-airflow[$(join ',' ${AIRFLOW_PACKAGES[@]})]==${AIRFLOW_VERSION}" \
        "lz4" "python-snappy" "airflow-exporter";

FROM base

COPY ./scripts/* /usr/local/bin/
COPY --chown=airflow:airflow ./runit /etc/airflow
COPY --from=builder /home/airflow/.local /home/airflow/.local

USER airflow
EXPOSE 8080 8793 5555
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
