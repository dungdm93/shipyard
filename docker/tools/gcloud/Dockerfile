FROM ghcr.io/dungdm93/tools/base:1.0

ARG GCLOUD_SDK_VERSION=327.*

# Install Google Cloud SDK
RUN set -eux; \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list; \
    curl "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | apt-key add -; \
    \
    apt-get update; \
    apt-get install -y "google-cloud-sdk=${GCLOUD_SDK_VERSION}"; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
