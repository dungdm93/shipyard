FROM hub.teko.vn/tools/base

RUN set -eux; \
    apt-get update; apt-get install -y jsonnet; \
    apt-get clean;  rm -rf /var/lib/apt/lists/*;

ARG JSONNET_BUNDLER_VERSION=v0.4.0
RUN set -eux; \
    curl -sSL "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JSONNET_BUNDLER_VERSION}/jb-linux-amd64" \
         -o /usr/local/bin/jb; \
    chmod +x /usr/local/bin/jb
