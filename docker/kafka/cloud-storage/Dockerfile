FROM confluentinc/cp-kafka-connect:7.0.0 AS confluent
SHELL ["/bin/bash", "-c"]

USER root
WORKDIR /build/plugins
ENV KAFKA_CONNECTOR_PATH=/usr/share/confluent-hub-components
RUN set -eux; \
    KAFKA_CONNECTOR=( \
        confluentinc/kafka-connect-s3:10.0.3 \
        confluentinc/kafka-connect-s3-source:1.4.9 \
        \
        confluentinc/kafka-connect-azure-blob-storage:1.6.4 \
        confluentinc/kafka-connect-azure-blob-storage-source:1.4.9 \
        confluentinc/kafka-connect-azure-data-lake-gen1-storage:1.6.4 \
        confluentinc/kafka-connect-azure-data-lake-gen2-storage:1.6.4 \
        \
        confluentinc/kafka-connect-gcs:5.5.10 \
        confluentinc/kafka-connect-gcs-source:1.4.9 \
        \
        confluentinc/kafka-connect-hdfs:10.1.1 \
        confluentinc/kafka-connect-hdfs2-source:1.4.9 \
        confluentinc/kafka-connect-hdfs3:1.1.5 \
        confluentinc/kafka-connect-hdfs3-source:1.4.9 \
        \
        streamthoughts/kafka-connect-file-pulse:2.4.0 \
    ); \
    for connector in ${KAFKA_CONNECTOR[@]}; do \
        confluent-hub install ${connector} --no-prompt; \
        # remove :version suffix
        plugin=${connector%%:*}; \
        # replace / by -
        plugin=${plugin//\//-}; \
        cp -r "${KAFKA_CONNECTOR_PATH}/${plugin}/lib" "./${plugin}"; \
    done

FROM ghcr.io/dungdm93/docker/kafka/connect:2.8.1

COPY --from=confluent /build/plugins /opt/kafka/plugins
