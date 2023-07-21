FROM python:3.10-slim as base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl3 libisal2 libnss3 libsasl2-modules \
        libpq5 libmariadb3 libodbc1 libct4 libsybdb5 \
        libldap-2.5-0 libkrb5-3 \
        curl locales;

# Firefox + Gecko driver. For Ubuntu, using `apt install firefox firefox-geckodriver`
ARG GECKO_DRIVER_VERSION=v0.33.0
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        xvfb libxi6 libgconf-2-4 \
        firefox-esr; \
    curl -sSL "https://github.com/mozilla/geckodriver/releases/download/${GECKO_DRIVER_VERSION}/geckodriver-${GECKO_DRIVER_VERSION}-linux64.tar.gz" \
        | tar -xzf - -C /usr/local/bin --no-same-owner;

RUN set -eux; \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8;

ENV SUPERSET_HOME="/opt/superset"
RUN set -eux; \
    useradd -ms "/bin/bash" --uid=1000 superset; \
    mkdir -p "${SUPERSET_HOME}"; \
    chown -R superset: "${SUPERSET_HOME}";

WORKDIR ${SUPERSET_HOME}

FROM base AS builder

ARG SUPERSET_VERSION=2.1.0

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y \
        build-essential pkg-config \
        # pip install pymssql
        freetds-dev \
        # pip install pyodbc
        unixodbc-dev \
        # pip install mysqlclient
        default-libmysqlclient-dev \
        # pip install pylibmc
        libmemcached-dev \
        # pip install sasl
        libsasl2-dev;

RUN --mount=type=cache,target=/root/.cache/pip \
    set -eux; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    # exasol | crate: ignore because SQLAlchemy version conflict
    # drill: pinned version 0.1.dev requires jpype
    # clickhouse: Unrecognized common setting `product_name`
    SUPERSET_PACKAGES=( \
        # Cloud
        athena bigquery redshift dynamodb \
        dremio databricks snowflake teradata \
        vertica firebolt rockset  \
        # Database
        mysql postgres mssql oracle hana solr \
        cockroachdb elasticsearch \
        excel gsheets \
        # Big Data
        druid hive impala kylin pinot \
        presto trino starrocks \
        # Others
        cors thumbnails \
    ); \
    pip install "apache-superset[$(join ',' ${SUPERSET_PACKAGES[@]})]==${SUPERSET_VERSION}" \
        # Remove those pinned when superset is upgrated to 2.1.1
        # => https://github.com/apache/superset/pull/22355
        # See https://github.com/pallets/markupsafe/issues/283
        # breaking change introduced in markupsafe causes jinja, flask to break
        "markupsafe<2.1" \
        # See https://github.com/apache/superset/issues/23742
        "sqlparse==0.4.3" \
        "marshmallow-enum" \
        "clickhouse-connect>=0.5.14, <1.0" \
        "sqlalchemy-drill>=1.1, <2.0"; \
    pip install \
        "gunicorn[gevent,eventlet]" "flower~=2.0" "authlib~=1.2" \
        "redis~=4.6" "pylibmc~=1.6" "statsd~=4.0" "prophet~=1.1"; \
    \
    rm -rf /usr/local/cx_Oracle-doc;

FROM base

COPY --from=builder /usr/local /usr/local
COPY --link ./scripts/* /usr/local/bin/

ENV FLASK_APP=superset
USER superset
EXPOSE 8088 5555
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
