FROM maven:3.6-jdk-8 AS downloader
SHELL ["/bin/bash", "-c"]
WORKDIR /app/

RUN set -eux; \
    apt-get update; \
    apt-get install -y curl tar;

COPY ./pom.xml /app/
RUN mvn dependency:resolve \
        dependency:copy-dependencies -DoutputDirectory=jars/;

ENV DEBEZIUM_VERSION=1.4.2.Final \
    MAVEN_REPO_CENTRAL=https://repo1.maven.org/maven2
RUN set -eux; \
    mkdir plugins/; \
    DEBEZIUM_CONNECTOR=( \
        mysql postgres mongodb \
        sqlserver oracle db2 \
        # cassandra vitess \
    ); \
    for connector in "${DEBEZIUM_CONNECTOR[@]}"; do \
        curl -sSL "${MAVEN_REPO_CENTRAL}/io/debezium/debezium-connector-${connector}/${DEBEZIUM_VERSION}/debezium-connector-${connector}-${DEBEZIUM_VERSION}-plugin.tar.gz" \
            | tar -xzvf - -C plugins --no-same-owner; \
    done

FROM quay.io/strimzi/kafka:0.22.1-kafka-2.7.0

COPY --from=downloader /app/jars/*  /opt/kafka/libs/
COPY --from=downloader /app/plugins /opt/kafka/plugins
