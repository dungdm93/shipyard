FROM alpine:3.18 AS downloader

WORKDIR /build
RUN apk add -U curl gnupg tar

# Main Apache distributions:
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
ARG APACHE_DIST=https://downloads.apache.org
ARG APACHE_MIRROR=${APACHE_DIST}
ARG HADOOP_VERSION=3.3.4

RUN set -eux; \
    curl -L  "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"; \
    curl -L  "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" \
           | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz";
RUN tar -xf  "hadoop-${HADOOP_VERSION}.tar.gz" --no-same-owner \
        --exclude="hadoop-*/share/doc"; \
    mv       "hadoop-${HADOOP_VERSION}" "hadoop";



FROM  ubuntu:jammy
LABEL maintainer="dungdm93"
SHELL [ "/bin/bash", "-c" ]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre-headless ca-certificates libc6 \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libssl3 libisal2 libnss3 libpam-modules krb5-user procps;

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    HADOOP_HOME="/opt/hadoop"

COPY --from=downloader "/build/hadoop" "${HADOOP_HOME}"

ENV PATH="${HADOOP_HOME}/bin:${PATH}"

# > hadoop checknative -a
# Native library checking:
# hadoop:  true /opt/hadoop/lib/native/libhadoop.so.1.0.0
# zlib:    true /lib/x86_64-linux-gnu/libz.so.1
# zstd:    true /lib/x86_64-linux-gnu/libzstd.so.1
# bzip2:   true /lib/x86_64-linux-gnu/libbz2.so.1
# openssl: true /lib/x86_64-linux-gnu/libcrypto.so
# ISA-L:   true /lib/x86_64-linux-gnu/libisal.so.2
# PMDK:    false The native code was built without PMDK support.
