FROM maven:3.6-jdk-8 AS downloader
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /build/plugins
WORKDIR /build/

COPY ./pom.xml /build/
RUN mvn dependency:resolve \
        dependency:copy-dependencies -DoutputDirectory=plugins/confluent-schema-registry/;

FROM quay.io/strimzi/kafka:0.34.0-kafka-3.4.0
LABEL maintainer="dungdm93"

COPY --from=downloader /build/plugins /opt/kafka/plugins
