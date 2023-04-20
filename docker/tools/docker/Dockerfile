FROM hub.teko.vn/tools/base:2.1

ARG DOCKER_VERSION=20.10.* \
    DOCKER_COMPOSE_VERSION=2.12.*
RUN set -eux; \
    source /etc/os-release; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -; \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" > /etc/apt/sources.list.d/docker.list; \
    \
    apt-get update; \
    apt-get install -y \
        "docker-ce-cli=5:${DOCKER_VERSION}" \
        "docker-compose-plugin=${DOCKER_COMPOSE_VERSION}"; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

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
