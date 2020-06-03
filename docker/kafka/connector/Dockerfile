ARG BASE_IMAGE

FROM maven:3.6-jdk-8 AS downloader

WORKDIR /app/
COPY ./pom.xml /app/
RUN set -eux; \
    mvn dependency:resolve; \
    mvn dependency:copy-dependencies -DoutputDirectory=jars/;

FROM ${BASE_IMAGE}

RUN set -eux; \
    confluent-hub install debezium/debezium-connector-mysql:1.1.0      --no-prompt; \
    confluent-hub install debezium/debezium-connector-postgresql:1.1.0 --no-prompt; \
    confluent-hub install debezium/debezium-connector-sqlserver:1.1.0  --no-prompt; \
    confluent-hub install debezium/debezium-connector-mongodb:1.1.0    --no-prompt; \
    confluent-hub install confluentinc/kafka-connect-datagen:0.3.2     --no-prompt;

COPY --from=downloader /app/jars/ /usr/share/java/kafka-connect-jdbc
