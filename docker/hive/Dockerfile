ARG HADOOP_VERSION=3.1.0

FROM alpine:3.10 AS downloader

WORKDIR /build
RUN apk add -U curl gnupg tar

# Main Apache distributions:
#   * https://apache.org/dist
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
# List all Apache mirrors:
#   * https://apache.org/mirrors
ARG APACHE_DIST=https://archive.apache.org/dist
ARG APACHE_MIRROR=${APACHE_DIST}
ARG HIVE_VERSION=3.1.3

RUN set -eux; \
    curl -L  "${APACHE_DIST}/hive/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"; \
    curl -L  "${APACHE_DIST}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc" \
           | gpg --batch --verify - "apache-hive-${HIVE_VERSION}-bin.tar.gz";
RUN tar -xf  "apache-hive-${HIVE_VERSION}-bin.tar.gz" --no-same-owner; \
    mv       "apache-hive-${HIVE_VERSION}-bin" "hive";

# PostgreSQL 14+ make SCRAM-SHA-256 as default require JDBC driver >=42.2
# https://stackoverflow.com/a/65758688
ARG POSTGRESQL_JDBC_VERSION=42.3.6
RUN set -eux; \
    cd ./hive/lib/; \
    rm -v postgresql-*.jre?.jar; \
    curl -LO "https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_JDBC_VERSION}/postgresql-${POSTGRESQL_JDBC_VERSION}.jar";

ARG ICEBERG_VERSION=0.13.2
ARG DELTALAKE_VERSION=0.4.1
RUN set -eux; \
    mkdir ./jars/; cd ./jars/; \
    curl -LO "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-hive-runtime/${ICEBERG_VERSION}/iceberg-hive-runtime-${ICEBERG_VERSION}.jar"; \
    curl -LO "https://github.com/delta-io/connectors/releases/download/v${DELTALAKE_VERSION}/delta-hive-assembly_2.11-${DELTALAKE_VERSION}.jar";

FROM hub.teko.vn/dataops/hadoop:${HADOOP_VERSION}

# Tools
RUN set -eux; \
    apt-get update; \
    apt-get install -y netcat; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ENV HIVE_HOME="/opt/hive" \
    PATH="/opt/hive/bin:${PATH}"

COPY --from=downloader "/build/hive"  "${HIVE_HOME}"
COPY --from=downloader "/build/jars/" "${HIVE_HOME}/lib/"

# COPY ./entrypoint.sh /opt/
# ENTRYPOINT [ "/opt/entrypoint.sh" ]
