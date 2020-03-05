FROM ubuntu:18.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        bash-completion \
        openssh-client \
        gnupg \
        curl \
        git;

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
    chmod +x /usr/local/bin/kubectl; \
    kubectl completion bash > /etc/bash_completion.d/kubectl;

# Install helm
ENV HELM_VERSION=v3.1.1
RUN set -eux; \
    curl -sSL "https://github.com/helm/helm/raw/master/scripts/get-helm-3" | bash -s -- --version "${HELM_VERSION}"; \
    helm completion bash > /etc/bash_completion.d/helm;

# Install rke
ENV RKE_VERSION=v1.0.4
RUN curl -sSL "https://github.com/rancher/rke/releases/download/${RKE_VERSION}/rke_linux-amd64" \
          -o /usr/local/bin/rke; \
    chmod +x /usr/local/bin/rke;

# Install helmfile
ENV HELMFILE_VERSION=v0.102.0
RUN curl -sSL "https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64" \
          -o /usr/local/bin/helmfile; \
    chmod +x /usr/local/bin/helmfile; \
    helm plugin install https://github.com/databus23/helm-diff --version=v3.1.1; \
    helm plugin install https://github.com/futuresimple/helm-secrets; \
    helm plugin install https://github.com/hypnoglow/helm-s3; \
    helm plugin install https://github.com/hayorov/helm-gcs;  \
    helm plugin install https://github.com/aslafy-z/helm-git;

# Install mc (minio client)
RUN curl -sSL "https://dl.min.io/client/mc/release/linux-amd64/mc" \
          -o /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc; \
    mc --autocompletion;

COPY ./settings/ssh.config /root/.ssh/config
