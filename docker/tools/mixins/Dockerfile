FROM ghcr.io/dungdm93/tools/terraform:1.0

# Jsonnet
ENV JSONNET_VERSION=v0.17.0
RUN set -eux; cd /usr/local/bin/; \
    curl -sSL "https://github.com/google/go-jsonnet/releases/download/${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION#v}_Linux_x86_64.tar.gz" \
        | tar -xzvf -; \
    rm -rf LICENSE README.md;

# jsonnet-bundler
ENV JSONNET_BUNDLER_VERSION=v0.4.0
RUN set -eux; cd /usr/local/bin/; \
    curl -sSL "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JSONNET_BUNDLER_VERSION}/jb-linux-amd64" \
        -o jb; \
    chmod +x jb;
