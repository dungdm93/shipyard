FROM python:3.10-slim
SHELL ["/bin/bash", "-c"]

ARG DOCKERIZE_VERSION=v0.6.1
RUN set -eux; \
    apt-get update; \
    apt-get install -y curl; \
    curl -sSL https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
        | tar -C /usr/local/bin -xzvf -; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    pip install --no-cache-dir 'acryl-datahub-actions[all]'; \
    mkdir -p /etc/datahub/actions/conf; \
    mkdir -p /etc/datahub/actions/system/conf;

# https://github.com/acryldata/datahub-actions/tree/main/docker/config
COPY ./config/*.yaml /etc/datahub/actions/system/conf/

COPY ./scripts/ /usr/local/bin/
