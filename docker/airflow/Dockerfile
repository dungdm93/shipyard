FROM python:3.7-slim-stretch AS base

LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

ENV AIRFLOW_HOME="/opt/airflow" \
    AIRFLOW_INSTALL_DIR="/usr/local/airflow"
ENV PATH="${AIRFLOW_INSTALL_DIR}/bin:${PATH}" \
    PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}${AIRFLOW_INSTALL_DIR}/lib/python3.7/site-packages/"

RUN mkdir -p "${AIRFLOW_HOME}"

FROM base AS builder

ARG AIRFLOW_VERSION=1.10.7

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

RUN set -eux; \
    mkdir -p ${AIRFLOW_INSTALL_DIR}; \
    # Speed up cassandra-driver installation
    export CASS_DRIVER_BUILD_CONCURRENCY=8; \
    pip install --prefix="${AIRFLOW_INSTALL_DIR}" \
        "apache-airflow[all]==${AIRFLOW_VERSION}" \
        "lz4" "python-snappy" \
        "pymssql<3.0";

FROM base

RUN set -eux; \
    apt-get update; \
    apt-get install -yqq --no-install-recommends \
        curl rsync netcat locales \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.1 libisal2 libnss3 \
        libmariadbclient18; \
    \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8; \
    \
    apt-get clean; \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY --from=builder "${AIRFLOW_INSTALL_DIR}" "${AIRFLOW_INSTALL_DIR}"
