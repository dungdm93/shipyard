FROM hub.teko.vn/tools/deployer:base

# Install kubectl
ENV KUBECTL_VERSION=v1.18.2
RUN set -eux; \
    curl -sSL "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
          -o /usr/local/bin/kubectl; \
    chmod +x /usr/local/bin/kubectl; \
    kubectl completion bash > /etc/bash_completion.d/kubectl;
