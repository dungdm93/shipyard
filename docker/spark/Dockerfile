FROM alpine:3.10 AS downloader

WORKDIR /build
RUN apk add -U curl gnupg tar

# Main Apache distributions:
#   * https://apache.org/dist
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
# List all Apache mirrors:
#   * https://apache.org/mirrors
ARG APACHE_DIST=https://downloads.apache.org
ARG APACHE_MIRROR=${APACHE_DIST}
ARG HADOOP_VERSION=3.2
ARG SPARK_VERSION=3.2.0
ARG TINI_VERSION=0.19.0

RUN set -eux; \
    curl -L  "${APACHE_DIST}/spark/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"; \
    curl -L  "${APACHE_DIST}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz.asc" \
           | gpg --batch --verify - "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz";
RUN tar -xf  "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" --no-same-owner; \
    mv       "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" "spark";

# Adding/Updating deps
# * guava: https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/spark-docker/Dockerfile
# * spark-hadoop-cloud: https://spark.apache.org/docs/latest/cloud-integration.html
RUN set -eux; cd "./spark/jars"; \
    rm guava-*.jar; \
    curl -LO "https://repo1.maven.org/maven2/com/google/guava/guava/23.0/guava-23.0.jar"; \
    curl -LO "https://repo1.maven.org/maven2/org/apache/spark/spark-hadoop-cloud_2.12/${SPARK_VERSION}/spark-hadoop-cloud_2.12-${SPARK_VERSION}.jar"

RUN set -eux; \
    curl -LO "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini"; \
    chmod +x tini;

FROM hub.teko.vn/dataops/hadoop:3.3.1 as hadoop
WORKDIR /build/hadoop

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl;

ARG HADOOP_TOOLS="hadoop-aliyun,hadoop-aws,hadoop-azure,hadoop-azure-datalake,hadoop-kafka,hadoop-openstack"

RUN set -eux; \
    mkdir -p "./lib/native/"; \
    cp -rT "${HADOOP_HOME}/lib/native/" "./lib/native/";

RUN set -eux; \
    mkdir -p "./libexec/shellprofile.d/"; \
    cp "${HADOOP_HOME}/libexec/hadoop-functions.sh" "./libexec/"; \
    for t in ${HADOOP_TOOLS//,/ }; do \
        cp "${HADOOP_HOME}/libexec/shellprofile.d/${t}.sh" "./libexec/shellprofile.d/"; \
    done;

COPY ./etc/hadoop-tools.sh ./bin/

RUN set -eux; \
    mkdir -p "./lib/tools/"; \
    export HADOOP_TOOLS_HOME="${HADOOP_HOME}"; \
    export HADOOP_TOOLS_LIB_JARS_DIR="share/hadoop/tools/lib"; \
    export HADOOP_LIBEXEC_DIR="$PWD/libexec"; \
    \
    for t in ${HADOOP_TOOLS//,/ }; do \
        export HADOOP_OPTIONAL_TOOLS="${t}"; \
        JARS="$(./bin/hadoop-tools.sh)"; \
        cp ${JARS//:/ } "./lib/tools/"; \
    done;

# Cloud Storage connector for Hadoop + Spark
# https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage
# https://github.com/GoogleCloudDataproc/hadoop-connectors/tree/master/gcs
COPY ./etc/hadoop-gcs.sh "./libexec/shellprofile.d/"
RUN set -eux; cd "./lib/tools/"; \
    curl -LO "https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop3-2.1.4.jar";

# BigQuery connector for Hadoop
# * https://cloud.google.com/dataproc/docs/concepts/connectors/bigquery
# * https://github.com/GoogleCloudDataproc/hadoop-connectors/tree/master/bigquery
# BigQuery connector for Spark
# * https://github.com/GoogleCloudDataproc/spark-bigquery-connector
# * https://cloud.google.com/dataproc/docs/tutorials/bigquery-connector-spark-example
COPY ./etc/hadoop-bigquery.sh "./libexec/shellprofile.d/"
RUN set -eux; cd "./lib/tools/"; \
    curl -LO "https://storage.googleapis.com/hadoop-lib/bigquery/bigquery-connector-hadoop3-1.1.4.jar"; \
    curl -LO "https://storage.googleapis.com/spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.17.1.jar";

FROM ubuntu:focal
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # Hadoop native packages
        openjdk-8-jre-headless ca-certificates libc6 \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libssl1.1 libisal2 libnss3 libpam-modules krb5-user procps \
        # Spark native packages
        libopenblas-base libatlas3-base libarpack2; \
    ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su; \
    chgrp root  /etc/passwd; \
    chmod ug+rw /etc/passwd;

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    SPARK_HOME="/opt/spark" \
    # https://spark.apache.org/docs/latest/ml-linalg-guide.html#spark-configuration
    OPENBLAS_NUM_THREADS=1 \
    MKL_NUM_THREADS=1

COPY --from=downloader /build/tini   /usr/bin/tini
COPY --from=downloader /build/spark  ${SPARK_HOME}
COPY --from=hadoop     /build/hadoop ${SPARK_HOME}/hadoop

ENV PATH="${SPARK_HOME}/bin:${PATH}" \
    LD_LIBRARY_PATH="${SPARK_HOME}/hadoop/lib/native:${LD_LIBRARY_PATH}"

COPY ./etc/spark-env.sh  "${SPARK_HOME}/conf/"
COPY ./entrypoint.sh     "/usr/local/bin/"

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
