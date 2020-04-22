# maven:3.6-jdk-8-slim (OpenJDK 1.8)
ARG MAVEN_IMAGE_SHA256=sha256:0d749fe156abc8f4d3d005aef2e2d43462e0b9f9c5eef32bf4af50b6d62ddc48
FROM maven@${MAVEN_IMAGE_SHA256} AS builder
SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        build-essential \
        python     \
        fontconfig \
        curl wget \
        git

# Main Apache distributions:
#   * https://apache.org/dist
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
# List all Apache mirrors:
#   * https://apache.org/mirrors
ARG APACHE_DIST=https://archive.apache.org/dist
ARG APACHE_MIRROR=${APACHE_DIST}
ARG RANGER_VERSION=2.0.0

RUN set -eux; \
    mkdir /build/; cd /build/; \
    curl -L  "${APACHE_DIST}/ranger/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/ranger/${RANGER_VERSION}/apache-ranger-${RANGER_VERSION}.tar.gz"; \
    curl -L  "${APACHE_MIRROR}/ranger/${RANGER_VERSION}/apache-ranger-${RANGER_VERSION}.tar.gz.asc" \
           | gpg --batch --verify - "apache-ranger-${RANGER_VERSION}.tar.gz"; \
    tar -xf  "apache-ranger-${RANGER_VERSION}.tar.gz"; \
    mv       "apache-ranger-${RANGER_VERSION}" "ranger"; \
    rm -rf   "apache-ranger-${RANGER_VERSION}.tar.gz";

WORKDIR /build/ranger

# mvn dependency:go-offline = mvn dependency:resolve dependency:resolve-plugins
RUN mvn dependency:go-offline

ARG SKIP_TESTS=true
RUN mvn -Pall -DskipTests=${SKIP_TESTS} clean compile package assembly:assembly

FROM ubuntu:bionic AS dist
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

COPY --from=builder /build/ranger/target/*.tar.gz /dist/
WORKDIR /dist
