FROM confluentinc/cp-kafka-connect:7.0.0 AS confluent
SHELL ["/bin/bash", "-c"]

USER root
WORKDIR /build/plugins
ENV KAFKA_CONNECTOR_PATH=/usr/share/confluent-hub-components
RUN set -eux; \
    KAFKA_CONNECTOR=( \
        confluentinc/kafka-connect-jdbc:10.2.5 \
        confluentinc/kafka-connect-elasticsearch:11.1.3 \
        dariobalinzo/kafka-connect-elasticsearch-source:1.3 \
        mongodb/kafka-connect-mongodb:1.6.1 \
        \
        # snowflakeinc/snowflake-kafka-connector:1.6.0 \
        # datastax/kafka-connect-cassandra-sink:1.4.0 \
        # confluentinc/kafka-connect-hbase:1.0.10 \
        # confluentinc/kafka-connect-kudu:1.0.2 \
        # apache/kafka-connect-geode:1.0.0 \
    ); \
    for connector in ${KAFKA_CONNECTOR[@]}; do \
        confluent-hub install ${connector} --no-prompt; \
        # remove :version suffix
        plugin=${connector%%:*}; \
        # replace / by -
        plugin=${plugin//\//-}; \
        cp -r "${KAFKA_CONNECTOR_PATH}/${plugin}/lib" "./${plugin}"; \
    done

FROM maven:3.6-jdk-8 AS downloader
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /build/plugins
WORKDIR /build/

COPY ./pom.xml /build/
RUN mvn dependency:resolve \
        dependency:copy-dependencies -DoutputDirectory=plugins/confluentinc-kafka-connect-jdbc/;

FROM hub.teko.vn/dataops/kafka/connect:2.8.1

COPY --from=confluent  /build/plugins /opt/kafka/plugins
COPY --from=downloader /build/plugins /opt/kafka/plugins
