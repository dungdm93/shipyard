FROM alpine:3.10 AS downloader

WORKDIR /build
RUN apk add -U curl gnupg tar

# Main Apache distributions:
#   * https://apache.org/dist
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
# List all Apache mirrors:
#   * https://apache.org/mirrors
ARG APACHE_DIST=https://archive.apache.org/dist
ARG APACHE_MIRROR=${APACHE_DIST}
ARG HADOOP_VERSION=3.2.1
ARG SPARK_VERSION=2.4.4

RUN set -eux; \
    curl -L  "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"; \
    curl -L  "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" \
           | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz";
RUN tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz"; \
    mv       "hadoop-${HADOOP_VERSION}" "hadoop";

RUN set -eux; \
    curl -L  "${APACHE_DIST}/spark/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    curl -L  "${APACHE_DIST}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz.asc" \
           | gpg --batch --verify - "spark-${SPARK_VERSION}-bin-without-hadoop.tgz";
RUN tar -xzf "spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    mv       "spark-${SPARK_VERSION}-bin-without-hadoop" "spark";



FROM jupyter/scipy-notebook

LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
USER root
SHELL [ "/bin/bash", "-c" ]
COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update -y; \
    apt-get install --no-install-recommends -y \
        gosu curl vim gettext-base tzdata openssh-client libsasl2-modules \
        iproute2 net-tools telnet dnsutils iputils-* htop iftop \
        openjdk-8-jre-headless; \
    cleanup.sh apt;

USER $NB_UID

ENV SPARK_HOME=/opt/spark   \
    HADOOP_HOME=/opt/hadoop \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

COPY --chown=$NB_UID:$NB_GID --from=downloader  /build/hadoop ${HADOOP_HOME}
COPY --chown=$NB_UID:$NB_GID --from=downloader  /build/spark  ${SPARK_HOME}
COPY --chown=$NB_UID:$NB_GID ./configs/spark/*  ${SPARK_HOME}/conf/
COPY --chown=$NB_UID:$NB_GID ./configs/hadoop/* ${HADOOP_HOME}/etc/hadoop/

ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip" \
    PATH="${SPARK_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"

# Database drivers
RUN set -eux; \
    conda install -y \
        python-dotenv \
        boost pyarrow \
        psycopg2      \
        mysqlclient   \
        pyodbc        \
        cx_oracle;    \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

# Widgets & visualization
RUN set -eux; \
    # ipywidgets ipyleaflet pythreejs bqplot
    conda install -y -c conda-forge \
        ipyleaflet=0.11.4 pythreejs bqplot; \
    jupyter labextension install \
        jupyter-leaflet@0.11.4 jupyter-threejs bqplot; \
    \
    # plotly
    conda install -y -c plotly \
        plotly plotly-orca plotly-geo psutil requests; \
    jupyter labextension install jupyterlab-plotly plotlywidget; \
    \
    # altair
    conda install -y -c conda-forge altair; \
    \
    # jupyterlab-sidecar
    pip install sidecar; \
    jupyter labextension install @jupyter-widgets/jupyterlab-sidecar; \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

# Tools
RUN set -eux; \
    conda install -y -c conda-forge jupyterlab-git; \
    jupyter labextension install jupyterlab-drawio; \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;
