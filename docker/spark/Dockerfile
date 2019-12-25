FROM ubuntu:bionic

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        openjdk-8-jre-headless ca-certificates-java \
        libc6 libpam-modules libnss3 \
        bash gnupg curl; \
    rm -rf /var/cache/apt/*; \
    \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su; \
    chgrp root /etc/passwd; \
    chmod ug+rw /etc/passwd;

RUN set -eux; \
    export TINI_VERSION=v0.18.0; \
    curl -sSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
         -o   /usr/bin/tini

COPY ./entrypoint.sh /opt/

ENV SPARK_VERSION=2.4.4  \
    HADOOP_VERSION=3.1.3 \
    SPARK_HOME=/opt/spark   \
    HADOOP_HOME=/opt/hadoop \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
WORKDIR /opt/spark/

# Main Apache distributions:
#   * https://apache.org/dist
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
# List all Apache mirrors:
#   * https://apache.org/mirrors
ARG APACHE_DIST=https://archive.apache.org/dist
ARG APACHE_MIRROR=${APACHE_DIST}

RUN set -eux; \
    cd /tmp;  \
    curl -sSL  "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    curl -sSLO "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"; \
    curl -sSL  "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz"; \
    tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" -C /opt --owner root --group root --no-same-owner; \
    rm  -rf  "hadoop-${HADOOP_VERSION}.tar.gz" "$HOME/.gnupg"; \
    mv  "/opt/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}";

RUN set -eux; \
    cd /tmp;  \
    curl -sSL  "${APACHE_DIST}/spark/KEYS" | gpg --batch --import -; \
    curl -sSLO "${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    curl -sSL  "${APACHE_DIST}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz.asc" | gpg --batch --verify - "spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    tar -xzf "spark-${SPARK_VERSION}-bin-without-hadoop.tgz" -C /opt --owner root --group root --no-same-owner; \
    rm  -rf  "spark-${SPARK_VERSION}-bin-without-hadoop.tgz" "$HOME/.gnupg"; \
    mv  "/opt/spark-${SPARK_VERSION}-bin-without-hadoop" "${SPARK_HOME}";

ENV PATH="${SPARK_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"

ENTRYPOINT [ "/opt/entrypoint.sh" ]
