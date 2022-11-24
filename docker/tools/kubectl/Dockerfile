FROM hub.teko.vn/tools/base:2.0

# Install kubectl
ENV KUBECTL_VERSION=v1.25.4
RUN set -eux; \
    curl -sSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
          -o /usr/local/bin/kubectl; \
    chmod +x /usr/local/bin/kubectl; \
    kubectl completion bash > /etc/bash_completion.d/kubectl;

ENV KUSTOMIZE_VERSION=v4.5.7
RUN set -eux; \
    curl -sSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" \
        | tar -xzvf - -C /usr/local/bin/; \
    kustomize completion bash > /etc/bash_completion.d/kustomize;

# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
RUN set -eux; \
    cd "$(mktemp -d)"; \
    OS="$(uname | tr '[:upper:]' '[:lower:]')"; \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"; \
    KREW="krew-${OS}_${ARCH}"; \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"; \
    tar zxvf "${KREW}.tar.gz"; \
    ./"${KREW}" install krew; \
    rm -rf $PWD;
ENV PATH="/root/.krew/bin:$PATH"

# https://github.com/kubernetes-sigs/krew-index/blob/master/plugins.md
RUN kubectl krew install \
        ctx ns tree oidc-login \
        # cilium calico cert-manager \
        # ingress-nginx virt \
        # sniff trace \
        popeye who-can

# Install mc (minio client)
RUN set -eux; \
    curl -sSL "https://dl.min.io/client/mc/release/linux-amd64/mc" \
          -o /usr/local/bin/mc; \
    chmod +x /usr/local/bin/mc;
