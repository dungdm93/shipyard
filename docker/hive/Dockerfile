ARG HADOOP_VERSION=3.2.1

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
ARG HIVE_VERSION=3.1.2

RUN set -eux; \
    curl -L  "${APACHE_DIST}/hive/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"; \
    curl -L  "${APACHE_DIST}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc" \
           | gpg --batch --verify - "apache-hive-${HIVE_VERSION}-bin.tar.gz";
RUN tar -xzf "apache-hive-${HIVE_VERSION}-bin.tar.gz"; \
    mv       "apache-hive-${HIVE_VERSION}-bin" "hive";



FROM hub.teko.vn/data/hadoop:${HADOOP_VERSION}

ENV HIVE_HOME=/opt/hive

COPY --from=downloader /build/hive  ${HIVE_HOME}
# COPY                   ./configs/*  ${SPARK_HOME}/conf/
# COPY ./entrypoint.sh /opt/

ENV PATH="${HIVE_HOME}/bin:${PATH}"

# ENTRYPOINT [ "/opt/entrypoint.sh" ]
