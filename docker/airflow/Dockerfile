FROM python:3.8-slim AS base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.1 libisal2 libnss3 \
        libpq5 libmariadb3 libodbc1 \
        libldap-2.4-2 libkrb5-3 \
        curl locales runit; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

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
        # pip install python-ldap
        libldap2-dev \
        # pip install python-snappy
        libsnappy-dev \
        # pip install unixodbc-dev
        unixodbc-dev \
        libev-dev

ARG AIRFLOW_VERSION=2.1.0

RUN set -eux; \
    PYTHON_VERSION_SHORT="${PYTHON_VERSION%.*}"; \
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION_SHORT}.txt"; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    AIRFLOW_PACKAGES=( \
        # Core
        http ftp ssh grpc \
        async cgroups redis rabbitmq \
        celery dask docker cncf.kubernetes \
        github_enterprise google_auth kerberos ldap password \
        # Database
        mysql postgres microsoft.mssql oracle mongo elasticsearch jdbc odbc \
        # Cloud Providers
        amazon microsoft.azure google \
        # BigData
        apache.beam apache.cassandra apache.druid apache.kylin apache.pinot \
        presto trino \
        # Others
        crypto slack sendgrid \
        sentry statsd hashicorp \
    ); \
    pip install --constraint "${CONSTRAINT_URL}" \
        "apache-airflow[$(join ',' ${AIRFLOW_PACKAGES[@]})]==${AIRFLOW_VERSION}";

RUN pip install \
        # force kubernetes>=12.0
        "kubernetes~=12.0" \
        "authlib~=0.15" \
        # extra packages
        "sqlparse~=0.4" \
        "lz4" "python-snappy";

RUN rm -rf \
        /usr/local/bin/__pycache__ \
        /usr/local/cx_Oracle-doc;

FROM base

COPY --from=builder /usr/local /usr/local
COPY --chown=airflow:airflow ./runit /etc/airflow/runit
COPY ./scripts/* /usr/local/bin/

USER airflow
EXPOSE 8080 8793 5555
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
