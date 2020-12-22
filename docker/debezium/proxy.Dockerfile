FROM confluentinc/cp-kafka-connect-base:6.0.1 AS builder
RUN confluent-hub install debezium/debezium-connector-mongodb:1.3.1 --no-prompt
RUN confluent-hub install debezium/debezium-connector-postgresql:1.3.1 --no-prompt
RUN confluent-hub install debezium/debezium-connector-mysql:1.3.1 --no-prompt
RUN confluent-hub install debezium/debezium-connector-sqlserver:1.3.1 --no-prompt

FROM quay.io/strimzi/kafka:latest-kafka-2.6.0
COPY --from=builder /usr/share/confluent-hub-components /opt/kafka/plugins/
USER root:root
COPY connect-runtime-2.6.0.jar /opt/kafka/libs/connect-runtime-2.6.0.jar
USER 1001
