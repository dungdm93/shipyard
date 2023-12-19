ARG HADOOP_VERSION=3.1.0

FROM alpine:3.10 AS downloader

WORKDIR /build
RUN apk add -U curl gnupg tar

ARG MAVEN_DIST=https://repo1.maven.org/maven2

ARG APACHE_DIST=https://archive.apache.org/dist
ARG HIVE_VERSION=3.1.2

RUN set -eux; \
    curl -L  "${APACHE_DIST}/hive/KEYS" | gpg --batch --import -; \
    curl -LO "${MAVEN_DIST}/org/apache/hive/hive-standalone-metastore/${HIVE_VERSION}/hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz"; \
    curl -L  "${MAVEN_DIST}/org/apache/hive/hive-standalone-metastore/${HIVE_VERSION}/hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz.asc" \
           | gpg --batch --verify - "hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz";
RUN tar -xf  "hive-standalone-metastore-${HIVE_VERSION}-bin.tar.gz" --no-same-owner; \
    mv       "apache-hive-metastore-${HIVE_VERSION}-bin" "hive";


ARG MYSQL_JDBC_VERSION=8.0.20
ARG POSTGRESQL_JDBC_VERSION=42.2.15
RUN set -eux; \
    mkdir jdbc-drivers; cd jdbc-drivers; \
    curl -LO "${MAVEN_DIST}/mysql/mysql-connector-java/${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}.jar"; \
    curl -LO "${MAVEN_DIST}/org/postgresql/postgresql/${POSTGRESQL_JDBC_VERSION}/postgresql-${POSTGRESQL_JDBC_VERSION}.jar";



FROM ghcr.io/dungdm93/docker/hadoop:${HADOOP_VERSION}

# Tools
RUN set -eux; \
    apt-get update; \
    apt-get install -y netcat; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ENV HIVE_HOME="/opt/hive" \
    PATH="/opt/hive/bin:${PATH}"

COPY --from=downloader "/build/hive" "${HIVE_HOME}"
COPY --from=downloader "/build/jdbc-drivers" "${HIVE_HOME}/lib"
# COPY ./entrypoint.sh /opt/
# ENTRYPOINT [ "/opt/entrypoint.sh" ]
