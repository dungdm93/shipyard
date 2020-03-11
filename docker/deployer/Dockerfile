FROM  ubuntu:18.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        bash-completion \
        openssh-client \
        gnupg \
        curl \
        git;

COPY ./settings/ssh.config /root/.ssh/config

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

# Install helm plugins
# RUN set -eux; \
#     helm plugin install https://github.com/databus23/helm-diff --version=v3.1.1; \
#     helm plugin install https://github.com/futuresimple/helm-secrets; \
#     helm plugin install https://github.com/hypnoglow/helm-s3; \
#     helm plugin install https://github.com/hayorov/helm-gcs;  \
#     helm plugin install https://github.com/aslafy-z/helm-git;
RUN set -eux; \
    export HELM_PLUGIN_HOME="${XDG_DATA_HOME:-$HOME/.local/share/helm}/plugins"; \
    mkdir -p "${HELM_PLUGIN_HOME}"; cd "${HELM_PLUGIN_HOME}"; \
    \
    echo "Installing helm-diff plugin"; \
    HELM_DIFF_VERSION=v3.1.1; \
    curl -sSL "https://github.com/databus23/helm-diff/releases/download/${HELM_DIFF_VERSION}/helm-diff-linux.tgz" \
        | tar -xzvf -; \
    mv diff helm-diff; \
    \
    echo "Installing helm-s3 plugin"; \
    mkdir helm-s3; \
    HELM_S3_VERSION=v0.9.2; \
    curl -sSL "https://github.com/hypnoglow/helm-s3/releases/download/${HELM_S3_VERSION}/helm-s3_${HELM_S3_VERSION#v}_linux_amd64.tar.gz" \
        | tar -xzvf - -C helm-s3; \
    \
    echo "Installing helm-gcs plugin"; \
    mkdir -p helm-gcs/scripts helm-gcs/bin; \
    HELM_GCS_VERSION=v0.3.1; \
    curl -sSL "https://github.com/hayorov/helm-gcs/releases/download/${HELM_GCS_VERSION#v}/helm-gcs_${HELM_GCS_VERSION#v}_Linux_x86_64.tar.gz" \
        | tar -xzvf - -C helm-gcs; \
    curl -sSL "https://github.com/hayorov/helm-gcs/raw/0.3.1/plugin.yaml"     -o "helm-gcs/plugin.yaml"; \
    curl -sSL "https://github.com/hayorov/helm-gcs/raw/0.3.1/scripts/pull.sh" -o "helm-gcs/scripts/pull.sh"; \
    mv "helm-gcs/helm-gcs" "helm-gcs/bin/"; \
    chmod +x "helm-gcs/scripts/pull.sh"; \
    \
    echo "Installing helm-git plugin"; \
    HELM_GIT_VERSION=v0.5.0; \
    curl -sSL "https://github.com/aslafy-z/helm-git/archive/${HELM_GIT_VERSION}.tar.gz" \
        | tar -xzvf -; \
    mv "helm-git-${HELM_GIT_VERSION#v}" "helm-git"; \
    rm -rf helm-git/{tests,*.json};

# Install rke
ENV RKE_VERSION=v1.0.4
RUN curl -sSL "https://github.com/rancher/rke/releases/download/${RKE_VERSION}/rke_linux-amd64" \
          -o /usr/local/bin/rke; \
    chmod +x /usr/local/bin/rke;

# Install helmfile
ENV HELMFILE_VERSION=v0.102.0
RUN curl -sSL "https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64" \
          -o /usr/local/bin/helmfile; \
    chmod +x /usr/local/bin/helmfile;
