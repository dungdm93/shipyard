FROM  ubuntu:20.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

ARG DEBIAN_FRONTEND=noninteractive
ENV YQ_VERSION=v3.4.1

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates gnupg openssl openssh-client bash-completion \
        curl git make tar zip unzip gzip bzip2 tree vim gettext-base jq \
        netcat iproute2 net-tools telnet iputils-* dnsutils; \
    curl -sSL https://github.com/mikefarah/yq/releases/download/${YQ_VERSION#v}/yq_linux_amd64 -o /usr/bin/yq; \
    chmod +x  /usr/bin/yq; \
    yq shell-completion > /etc/bash_completion.d/yq; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY ./rootfs /
