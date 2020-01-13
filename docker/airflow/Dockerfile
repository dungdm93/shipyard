FROM python:3.7-slim-stretch AS base

LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

ENV AIRFLOW_HOME="/opt/airflow"
ENV PATH="${PATH}:${AIRFLOW_HOME}/bin" \
    PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}${AIRFLOW_HOME}/lib/python3.7/site-packages/"

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
        libkrb5-dev;

RUN set -eux; \
    mkdir -p ${AIRFLOW_HOME}; \
    pip install --prefix="${AIRFLOW_HOME}" \
        'pymssql<3.0' 'apache-airflow[all]';

FROM base

RUN set -eux; \
    apt-get update; \
    apt-get install -yqq --no-install-recommends \
        libmariadbclient18 \
        curl rsync netcat locales; \
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

COPY --from=builder "${AIRFLOW_HOME}" "${AIRFLOW_HOME}"
