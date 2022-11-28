FROM hub.teko.vn/tools/base:2.0

# Terraform
ENV TERRAFORM_VERSION=1.3.*
RUN set -eux; \
    source /etc/os-release; \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/hashicorp.list; \
    \
    apt-get update; \
    apt-get install -y "terraform=${TERRAFORM_VERSION}"; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Terragrunt
ENV TERRAGRUNT_VERSION=v0.41.0
RUN set -eux; cd /usr/local/bin/; \
    curl -L  "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
         -o  terragrunt; \
    chmod +x terragrunt;

COPY ./scripts /usr/local/bin/
