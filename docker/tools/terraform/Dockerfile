FROM hub.teko.vn/tools/base:1.0

# Terraform
ENV TERRAFORM_VERSION=1.0.*
RUN set -eux; \
    source /etc/os-release; \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -; \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/hashicorp.list; \
    \
    apt-get update; \
    apt-get install -y "terraform=${TERRAFORM_VERSION}"; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Terragrunt
ENV TERRAGRUNT_VERSION=v0.31.3
RUN set -eux; cd /usr/local/bin/; \
    curl -L  "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
         -o  terragrunt; \
    chmod +x terragrunt;

# https://www.terraform.io/docs/cli/config/config-file.html#provider-installation
ENV TERRAFORM_LOCAL_MIRROR_DIR=/usr/local/share/terraform/plugins/
WORKDIR ${TERRAFORM_LOCAL_MIRROR_DIR}
COPY providers.tf ./
RUN terraform providers mirror "${TERRAFORM_LOCAL_MIRROR_DIR}"

COPY ./scripts /usr/local/bin/
