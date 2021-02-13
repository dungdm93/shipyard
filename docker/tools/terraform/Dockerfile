# ref:
# * https://github.com/hashicorp/terraform/blob/guide-v0.13-beta/draft-upgrade-guide.md
# * https://github.com/hashicorp/terraform/blob/master/website/docs/commands/cli-config.html.markdown#provider-installation
FROM hub.teko.vn/tools/base:1.0

# Terraform
ENV TERRAFORM_VERSION=v0.13.2
RUN set -eux; cd /usr/local/bin/; \
    curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION#v}/terraform_${TERRAFORM_VERSION#v}_linux_amd64.zip"; \
    unzip -o terraform_*_linux_amd64.zip; \
    rm -rf terraform_*_linux_amd64.zip; \
    terraform -install-autocomplete;

# Terragrunt
ENV TERRAGRUNT_VERSION=v0.23.40
RUN set -eux; cd /usr/local/bin/; \
    curl -L  "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
         -o  terragrunt; \
    chmod +x terragrunt;

ENV TERRAFORM_LOCAL_MIRROR_DIR=/usr/local/share/terraform/plugins/
WORKDIR ${TERRAFORM_LOCAL_MIRROR_DIR}

# Providers
COPY providers.tf ./
RUN terraform providers mirror "${TERRAFORM_LOCAL_MIRROR_DIR}"

ENV PROVIDER_MINIO_VERSION=v1.1.0 \
    PROVIDER_NEXUS_VERSION=v1.10.2 \
    PROVIDER_KEYCLOAK_VERSION=v1.20.0

# MinIO provider
RUN set -eux; \
    PROVIDER_DIR="github.com/aminueza/minio/${PROVIDER_MINIO_VERSION#v}/linux_amd64/"; \
    mkdir -p $PROVIDER_DIR; cd $PROVIDER_DIR; \
    curl -L  "https://github.com/aminueza/terraform-provider-minio/releases/download/${PROVIDER_MINIO_VERSION}/terraform-provider-minio_${PROVIDER_MINIO_VERSION}_linux_amd64" \
         -o  "terraform-provider-minio_${PROVIDER_MINIO_VERSION}"; \
    chmod +x terraform-provider-minio_*;

# Nexus provider
RUN set -eux; \
    PROVIDER_DIR="github.com/datadrivers/nexus/${PROVIDER_NEXUS_VERSION#v}/linux_amd64/"; \
    mkdir -p $PROVIDER_DIR; cd $PROVIDER_DIR; \
    curl -L  "https://github.com/datadrivers/terraform-provider-nexus/releases/download/${PROVIDER_NEXUS_VERSION}/terraform-provider-nexus_${PROVIDER_NEXUS_VERSION}_linux_amd64.tar.gz" | \
        tar -xzf -;

# KeyCloak provider
RUN set -eux; \
    PROVIDER_DIR="github.com/mrparkers/keycloak/${PROVIDER_KEYCLOAK_VERSION#v}/linux_amd64/"; \
    mkdir -p $PROVIDER_DIR; cd $PROVIDER_DIR; \
    curl -LO "https://github.com/mrparkers/terraform-provider-keycloak/releases/download/${PROVIDER_KEYCLOAK_VERSION#v}/terraform-provider-keycloak_${PROVIDER_KEYCLOAK_VERSION}_linux_amd64.zip"; \
    unzip terraform-provider-keycloak_*.zip "terraform-*"; \
    rm -rf terraform-provider-keycloak_*.zip;

COPY ./scripts /usr/local/bin/
