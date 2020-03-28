FROM python:3.7-slim-stretch AS base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

ENV AIRFLOW_HOME="/opt/airflow" \
    AIRFLOW_INSTALL_DIR="/usr/local/airflow"
ENV PATH="${AIRFLOW_INSTALL_DIR}/bin:${PATH}" \
    PYTHONPATH="${PYTHONPATH}:${AIRFLOW_INSTALL_DIR}/lib/python3.7/site-packages/"

RUN set -eux; \
    useradd -ms "/bin/bash" --uid=1000 airflow; \
    mkdir -p "${AIRFLOW_HOME}"; \
    chown -R airflow: "${AIRFLOW_HOME}";

WORKDIR ${AIRFLOW_HOME}

FROM base AS builder

ARG AIRFLOW_VERSION=1.10.9

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
    function join { local IFS="$1"; echo "${*:2}"; }; \
    AIRFLOW_PACKAGES=( \
        # Executor
        celery dask docker kubernetes \
        # Database
        mysql postgres mongo jdbc \
        # Celery Broker
        # rabbitmq installed bellow
        redis \
        # Authentication
        password ldap kerberos google_auth github_enterprise \
        # Cloud Providers
        aws azure gcp \
        # BigData
        hdfs hive presto \
        # Others
        async crypto ssh slack sendgrid \
    ); \
    mkdir -p ${AIRFLOW_INSTALL_DIR}; \
    pip install --prefix="${AIRFLOW_INSTALL_DIR}" \
        "apache-airflow[$(join ',' ${AIRFLOW_PACKAGES[@]})]==${AIRFLOW_VERSION}" \
        "lz4" "python-snappy" "airflow-exporter";

FROM base

RUN set -eux; \
    apt-get update; \
    apt-get install -yqq --no-install-recommends \
        curl runit rsync netcat locales \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.1 libisal2 libnss3 \
        libmariadbclient18; \
    \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8; \
    rm -rf /etc/service; \
    mkdir -p /etc/service; \
    chown -R airflow: /etc/service; \
    \
    apt-get clean; \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

RUN set -eux; \
    pip install --no-cache-dir \
        # TODO: error while pip install with --prefix
        "librabbitmq";

COPY --from=builder "${AIRFLOW_INSTALL_DIR}" "${AIRFLOW_INSTALL_DIR}"
COPY ./scripts/* /usr/local/bin/
COPY --chown=airflow:airflow ./runit /etc/airflow

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
EXPOSE 8080 8793 5555
USER airflow
