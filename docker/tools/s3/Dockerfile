FROM ghcr.io/dungdm93/tools/base:1.0

# Install mc (minio client)
RUN set -eux; \
    curl -sSL "https://dl.min.io/client/mc/release/linux-amd64/mc" \
          -o /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc; \
    mc --autocompletion;

RUN set -eux; \
    apt-get update; apt-get install -y s3cmd; \
    apt-get clean; rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh "/usr/local/bin/"
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
