FROM python:3.10-slim AS base
LABEL maintainer="dungdm93"
SHELL ["/bin/bash", "-c"]

ARG ACRYL_DATAHUB_VERSION=0.11.0

RUN  --mount=type=cache,target=/root/.cache/pip \
    set -eux; \
    pip install "acryl-datahub[datahub-rest]==${ACRYL_DATAHUB_VERSION}"; \
    rm -rf /usr/local/bin/__pycache__

COPY ./scripts /opt/scripts
RUN chmod -R +x /opt/scripts

ENTRYPOINT [ "/opt/scripts/publish-lineage.py" ]
