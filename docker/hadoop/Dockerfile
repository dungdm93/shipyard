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
ARG HADOOP_VERSION=3.2.1

RUN set -eux; \
    curl -L  "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"; \
    curl -L  "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" \
           | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz";
RUN tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz"; \
    mv       "hadoop-${HADOOP_VERSION}" "hadoop";



FROM ubuntu:bionic
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre-headless krb5-user \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libssl1.1 libisal2 libnss3; \
    ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so; \
    ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so;    \
    rm -rf /var/cache/apt/*;

# TODO: Native Hadoop Library
# > hadoop checknative -a
# * libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1
# * libssl1.1
#   ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so
#   ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so
# * libisal2
#   ln -s libisal.so.2     /usr/lib/x86_64-linux-gnu/libisal.so

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    HADOOP_HOME=/opt/hadoop

COPY --from=downloader /build/hadoop ${HADOOP_HOME}
COPY                  ./configs/*    ${HADOOP_HOME}/etc/hadoop/

ENV PATH="${HADOOP_HOME}/bin:${PATH}"
