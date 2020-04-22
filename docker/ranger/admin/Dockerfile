ARG RANGER_VERSION=2.0.0
FROM hub.teko.vn/data/ranger:${RANGER_VERSION}-dist AS builder

ENV RANGER_HOME=/opt/ranger
ARG RANGER_VERSION=2.0.0
RUN set -eux; \
    tar -xzvf ranger-${RANGER_VERSION}-admin.tar.gz; \
    mv ranger-${RANGER_VERSION}-admin /opt/ranger;

WORKDIR "${RANGER_HOME}"
RUN set -eux; \
    mkdir "${RANGER_HOME}/conf"; \
    ln -s "${RANGER_HOME}/conf" "${RANGER_HOME}/ews/webapp/WEB-INF/classes/conf";

FROM ubuntu:bionic
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre-headless \
        ca-certificates \
        python; \
    rm -rf /var/cache/apt/*;

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    RANGER_HOME=/opt/ranger

COPY --from=builder "${RANGER_HOME}" "${RANGER_HOME}"
