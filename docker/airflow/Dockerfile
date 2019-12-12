FROM python:3.7-slim-stretch

LABEL maintainer="Dũng Đặng Minh <dungdm93@live.com>"

ENV AIRFLOW_HOME="/airflow" \
    PATH="${PATH}:/airflow/bin" \
    PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}${AIRFLOW_HOME}/lib/python3.7/site-packages/"

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        build-essential \
        # pip install mysqlclient
        default-libmysqlclient-dev \
        # pip install sasl
        libsasl2-dev \
        # pip install pykerberos
        libkrb5-dev; \
    mkdir -p ${AIRFLOW_HOME}; \
    pip install --prefix="${AIRFLOW_HOME}" \
        'pymssql<3.0' 'apache-airflow[all]';
