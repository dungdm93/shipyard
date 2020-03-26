FROM golang:1.14-alpine AS bundler

RUN apk add -U git unzip;

RUN set -eux; \
    go get -d  github.com/hashicorp/terraform; \
    go install github.com/hashicorp/terraform/tools/terraform-bundle

COPY terraform-bundle.hcl /terraform/
WORKDIR /terraform

RUN set -eux; \
    terraform-bundle package terraform-bundle.hcl; \
    mkdir -p bundle; \
    unzip -d bundle terraform_*.zip

####################
FROM hub.teko.vn/library/deployer:base

COPY --from=bundler /terraform/bundle/terraform            /usr/local/bin/
COPY --from=bundler /terraform/bundle/terraform-provider-* /root/.terraform.d/plugins/

RUN terraform -install-autocomplete
