FROM ghcr.io/dungdm93/tools/s3:1.0

ENV WARP_VERSION=v0.3.40
RUN set -eux; \
    cd /usr/local/bin/; \
    curl -sSL "https://github.com/minio/warp/releases/download/${WARP_VERSION}/warp_${WARP_VERSION#v}_Linux_x86_64.tar.gz" \
        | tar -xzvf - warp; \
    warp --autocompletion;
