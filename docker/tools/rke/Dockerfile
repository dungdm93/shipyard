FROM ghcr.io/dungdm93/tools/kubectl:1.25

# Install rke
ENV RKE_VERSION=v1.4.8
RUN set -eux; \
    curl -sSL "https://github.com/rancher/rke/releases/download/${RKE_VERSION}/rke_linux-amd64" \
          -o /usr/local/bin/rke; \
    chmod +x /usr/local/bin/rke;
