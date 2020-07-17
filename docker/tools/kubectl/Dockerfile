FROM hub.teko.vn/tools/base

# Install kubectl
ENV KUBECTL_VERSION=v1.18.2
RUN set -eux; \
    curl -sSL "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
          -o /usr/local/bin/kubectl; \
    chmod +x /usr/local/bin/kubectl; \
    kubectl completion bash > /etc/bash_completion.d/kubectl;

ENV KUSTOMIZE_VERSION=v3.6.1
RUN set -eux; \
    curl -sSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" \
        | tar -xzvf - -C /usr/local/bin/; \
    echo yes | kustomize install-completion;

# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
RUN set -eux; \
    cd "$(mktemp -d)"; \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}"; \
    tar -xzvf krew.tar.gz; \
    KREW="./krew-$(uname | tr '[:upper:]' '[:lower:]')_amd64"; \
    "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz; \
    "$KREW" update; \
    rm -rf $PWD;
ENV PATH="/root/.krew/bin:$PATH"

# https://github.com/kubernetes-sigs/krew-index/blob/master/plugins.md
RUN kubectl krew install \
        ctx ns \
        tree view-secret \
        # ingress-nginx \
        # kudo kuttl virt \
        # sniff trace \
        popeye who-can

# Install mc (minio client)
RUN set -eux; \
    curl -sSL "https://dl.min.io/client/mc/release/linux-amd64/mc" \
          -o /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc; \
    mc --autocompletion;
