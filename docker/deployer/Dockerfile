FROM ubuntu:18.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

RUN set -eux; \
    apt-get update; \
    apt-get install -y openssh-client gnupg curl;

# Install Google Cloud SDK
RUN set -eux; \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list; \
    curl "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | apt-key add -; \
    \
    apt-get update; \
    apt-get install -y google-cloud-sdk;

# Install kubectl
ENV KUBECTL_VERSION=v1.17.3
RUN set -eux; \
    curl -sSL "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
          -o /usr/local/bin/kubectl; \
    chmod +x /usr/local/bin/kubectl;

# Install helm
ENV HELM_VERSION=v3.1.1
RUN curl -sSL "https://github.com/helm/helm/raw/master/scripts/get-helm-3" | bash -s -- --version "${HELM_VERSION}"

# Install rke
ENV RKE_VERSION=v1.0.4
RUN curl -sSL "https://github.com/rancher/rke/releases/download/${RKE_VERSION}/rke_linux-amd64" \
          -o /usr/local/bin/rke; \
    chmod +x /usr/local/bin/rke;

# Install mc (minio client)
RUN curl -sSL "https://dl.min.io/client/mc/release/linux-amd64/mc" \
          -o /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc;

COPY ./settings/ssh.config /root/.ssh/config
