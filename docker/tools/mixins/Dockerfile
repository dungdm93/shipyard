FROM golang:1.15-buster AS builder

ARG GRIZZLY_REVISION=242b5b3
RUN set -eux; \
    mkdir /app; \
    git clone https://github.com/grafana/grizzly.git /app/grizzly; \
    cd /app/grizzly; \
    git checkout ${GRIZZLY_REVISION}

WORKDIR /app/grizzly
RUN make install

FROM hub.teko.vn/tools/base:1.0

RUN set -eux; \
    apt-get update; apt-get install -y jsonnet; \
    apt-get clean;  rm -rf /var/lib/apt/lists/*;

ARG JSONNET_BUNDLER_VERSION=v0.4.0
RUN set -eux; \
    curl -sSL "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JSONNET_BUNDLER_VERSION}/jb-linux-amd64" \
         -o /usr/local/bin/jb; \
    chmod +x /usr/local/bin/jb

COPY --from=builder /go/bin/grr /usr/local/bin/
RUN grr complete
