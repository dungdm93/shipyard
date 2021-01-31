FROM maven:3.6-jdk-8 AS downloader

WORKDIR /app/
COPY ./pom.xml /app/
RUN mvn dependency:resolve \
        dependency:copy-dependencies -DoutputDirectory=jars/;

FROM strimzi/kafka:0.20.0-kafka-2.6.0

COPY --from=downloader /app/jars/* /opt/kafka/libs/
