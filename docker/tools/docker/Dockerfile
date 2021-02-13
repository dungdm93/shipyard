FROM hub.teko.vn/tools/base:1.0

ARG DOCKER_VERSION=20.10.*
RUN set -eux; \
    source /etc/os-release; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -; \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" > /etc/apt/sources.list.d/docker.list; \
    \
    apt-get update; \
    apt-get install -y "docker-ce-cli=5:${DOCKER_VERSION}"; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ARG DOCKER_COMPOSE_VERSION=1.26.0
RUN set -eux; \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION#v}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; \
    chmod +x /usr/local/bin/docker-compose; \
    curl -L "https://github.com/docker/compose/raw/${DOCKER_COMPOSE_VERSION#v}/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose;
