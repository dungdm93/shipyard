FROM hub.teko.vn/tools/kubectl:1.25

# Install helm
ENV HELM_VERSION=v3.10.3
RUN set -eux; \
    curl -sSL "https://github.com/helm/helm/raw/main/scripts/get-helm-3" | bash -s -- --version "${HELM_VERSION}"; \
    helm completion bash > /etc/bash_completion.d/helm;

# Install helm plugins
# RUN set -eux; \
#     helm plugin install https://github.com/databus23/helm-diff --version=v3.1.1; \
#     helm plugin install https://github.com/chartmuseum/helm-push.git; \
#     helm plugin install https://github.com/futuresimple/helm-secrets; \
#     helm plugin install https://github.com/aslafy-z/helm-git; \
#     helm plugin install https://github.com/hypnoglow/helm-s3; \
#     helm plugin install https://github.com/hayorov/helm-gcs;
RUN set -eux; \
    source <(helm env); \
    mkdir -p "${HELM_PLUGINS}"; cd "${HELM_PLUGINS}"; \
    \
    echo "Installing helm-push plugin"; \
    HELM_PUSH_VERSION=v0.10.3; \
    mkdir -p helm-push; \
    curl -sSL "https://github.com/chartmuseum/helm-push/releases/download/${HELM_PUSH_VERSION}/helm-push_${HELM_PUSH_VERSION#v}_linux_amd64.tar.gz" \
        | tar -xzvf - -C helm-push; \
    \
    echo "Installing helm-diff plugin"; \
    HELM_DIFF_VERSION=v3.6.0; \
    curl -sSL "https://github.com/databus23/helm-diff/releases/download/${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz" \
        | tar -xzvf -; \
    mv diff helm-diff;

# Install helmfile
ENV HELMFILE_VERSION=v0.149.0
RUN set -eux; \
    curl -sSL "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz" \
          | tar -C /usr/local/bin/ -xzvf - helmfile;

# Install vault
ENV VAULT_VERSION=1.12.*
RUN set -eux; \
    source /etc/os-release; \
    curl -sSL "https://apt.releases.hashicorp.com/gpg" | gpg --dearmor --output "/usr/share/keyrings/hashicorp-archive-keyring.gpg"; \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" > "/etc/apt/sources.list.d/hashicorp.list"; \
    apt-get update; \
    apt-get install "vault=${VAULT_VERSION}"; \
    # https://github.com/hashicorp/vault/issues/10924#issuecomment-979904664
    setcap -r $(which vault); \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
