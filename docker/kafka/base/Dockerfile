FROM maven:3.6-jdk-8 AS downloader
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /build/plugins
WORKDIR /build/

COPY ./pom.xml /build/
RUN mvn dependency:resolve \
        dependency:copy-dependencies -DoutputDirectory=plugins/confluent-schema-registry/;

FROM quay.io/strimzi/kafka:0.32.0-kafka-3.3.1
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

COPY --from=downloader /build/plugins /opt/kafka/plugins
