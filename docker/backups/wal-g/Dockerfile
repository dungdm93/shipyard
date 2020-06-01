FROM ubuntu:20.04

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        curl pv liblzo2-2 libsodium23 \
        mysql-client \
        postgresql-client \
        mongodb-clients \
        redis-tools

ARG WALG_VERSION=v0.2.15

RUN set -eux; \
    curl -L https://github.com/wal-g/wal-g/releases/download/${WALG_VERSION}/wal-g.linux-amd64.tar.gz | \
        tar -xzf - -C /usr/local/bin;

# ref: https://severalnines.com/database-blog/postgresql-backup-method-features-aws-s3
