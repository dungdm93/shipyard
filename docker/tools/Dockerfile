FROM  ubuntu:20.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates gnupg openssl openssh-client \
        bash-completion netcat iproute2 curl git make \
        net-tools telnet iputils-* dnsutils \
        tree vim gettext-base jq; \
    curl -sSL https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -o /usr/bin/yq; \
    chmod +x  /usr/bin/yq; \
    yq shell-completion > /etc/bash_completion.d/yq; \
    \
    rm -rf /var/lib/apt/lists/*;

COPY ./rootfs /