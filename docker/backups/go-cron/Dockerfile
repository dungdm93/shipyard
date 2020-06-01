FROM ubuntu:20.04

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        curl pv liblzo2-2 libsodium23 \
        mysql-client \
        postgresql-client \
        mongodb-clients \
        redis-tools

ARG GO_CRON=v0.0.7

RUN set -eux; \
    curl -sSL https://github.com/odise/go-cron/releases/download/${GO_CRON}/go-cron-linux.gz | gunzip - > /usr/local/bin/go-cron; \
    chmod +x /usr/local/bin/go-cron;

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
