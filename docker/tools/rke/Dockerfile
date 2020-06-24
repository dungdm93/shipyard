FROM hub.teko.vn/tools/kubectl

# Install rke
ENV RKE_VERSION=v1.1.3
RUN curl -sSL "https://github.com/rancher/rke/releases/download/${RKE_VERSION}/rke_linux-amd64" \
          -o /usr/local/bin/rke; \
    chmod +x /usr/local/bin/rke;
