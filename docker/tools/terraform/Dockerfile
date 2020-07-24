FROM golang:1.14-alpine AS bundler

RUN apk add -U git curl unzip;

ARG GO111MODULE=on
ARG TERRAFORM_VERSION=v0.12.26
RUN go get -u github.com/hashicorp/terraform/tools/terraform-bundle@${TERRAFORM_VERSION}

COPY terraform-bundle.hcl /terraform/
WORKDIR /terraform

ENV PROVIDER_MINIO_VERSION=v1.1.0 \
    PROVIDER_NEXUS_VERSION=v1.8.1 \
    PROVIDER_KEYCLOAK_VERSION=v1.20.0

RUN set -eux; \
    terraform-bundle package terraform-bundle.hcl; \
    mkdir -p bundle; \
    unzip -d bundle terraform_*.zip

# MinIO provider
RUN set -eux; cd bundle; \
    curl -L  https://github.com/aminueza/terraform-provider-minio/releases/download/${PROVIDER_MINIO_VERSION}/terraform-provider-minio_${PROVIDER_MINIO_VERSION}_linux_amd64 \
         -o  terraform-provider-minio_${PROVIDER_MINIO_VERSION}; \
    chmod +x terraform-provider-minio_${PROVIDER_MINIO_VERSION};

# Nexus provider
RUN set -eux; cd bundle; \
    curl -L  https://github.com/datadrivers/terraform-provider-nexus/releases/download/${PROVIDER_NEXUS_VERSION}/terraform-provider-nexus_${PROVIDER_NEXUS_VERSION}_linux_amd64.tar.gz | \
        tar -xzf -;

# KeyCloak provider
RUN set -eux; cd bundle; \
    curl -LO https://github.com/mrparkers/terraform-provider-keycloak/releases/download/${PROVIDER_KEYCLOAK_VERSION#v}/terraform-provider-keycloak_${PROVIDER_KEYCLOAK_VERSION}_linux_amd64.zip; \
    unzip terraform-provider-keycloak_*.zip "terraform-*"; \
    rm -rf terraform-provider-keycloak_*.zip;

####################
FROM hub.teko.vn/tools/base

COPY --from=bundler /terraform/bundle/terraform-provider-* /root/.terraform.d/plugins/
COPY --from=bundler /terraform/bundle/terraform            /usr/local/bin/
COPY                ./scripts                              /usr/local/bin/

RUN terraform -install-autocomplete
