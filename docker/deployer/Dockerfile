FROM  ubuntu:20.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        ca-certificates gnupg openssl openssh-client \
        bash-completion iproute2 curl \
        net-tools telnet iputils-* dnsutils \
        git vim gettext-base; \
    rm -rf /var/lib/apt/lists/*;

COPY ./settings/ssh.config /root/.ssh/config
