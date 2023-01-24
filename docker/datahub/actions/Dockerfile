FROM python:3.10-slim
SHELL ["/bin/bash", "-c"]

ARG DOCKERIZE_VERSION=v0.6.1
RUN set -eux; \
    apt-get update; \
    apt-get install -y curl; \
    curl -sSL "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
        | tar -C /usr/local/bin -xzvf -; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    pip install --no-cache-dir "acryl-datahub-actions[all]"; \
    # see: https://github.com/acryldata/datahub-actions/blob/main/docker/datahub-actions/Dockerfile#L30
    mkdir -p /etc/datahub/actions/{,system}/conf; \
    # see: acryl.executor.execution.sub_process_ingestion_task.SubProcessIngestionTaskConfig
    mkdir -p /tmp/datahub/{ingest,logs};

# https://github.com/acryldata/datahub-actions/tree/main/docker/config
COPY ./config/*.yaml /etc/datahub/actions/system/conf/

# https://github.com/acryldata/datahub-actions/blob/main/docker/datahub-actions/start.sh
COPY ./scripts/start_datahub_actions.sh /usr/local/bin/

RUN set -eux; \
    useradd -rms "/bin/bash" datahub; \
    chown -R datahub:datahub /etc/datahub/ /tmp/datahub/;
USER datahub

CMD ["/usr/local/bin/start_datahub_actions.sh"]
