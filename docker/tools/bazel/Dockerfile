FROM ghcr.io/dungdm93/tools/base:2.1

ARG BAZEL_VERSION=6.3.2

RUN set -eux; \
    source /etc/os-release; \
    apt update; \
    apt install -y \
        wget gcc python3 g++ glibc-source libc++-11-dev libc++abi-11-dev openjdk-17-jdk libssl-dev pkg-config libz-dev zlib1g-dev; \
    wget -q -O /usr/local/bin/bazel "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64"; \
    chmod +x /usr/local/bin/bazel; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
