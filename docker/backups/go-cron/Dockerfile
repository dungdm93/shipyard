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
    curl -sSL "https://github.com/odise/go-cron/releases/download/${GO_CRON}/go-cron-linux.gz" | gunzip - > /usr/local/bin/go-cron; \
    chmod +x /usr/local/bin/go-cron;

RUN set -eux; \
    curl -sSL "https://dl.min.io/client/mc/release/linux-amd64/mc" \
          -o /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc; \
    mc --autocompletion;

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./scripts              /usr/scripts/
ENTRYPOINT [ "/docker-entrypoint.sh" ]
