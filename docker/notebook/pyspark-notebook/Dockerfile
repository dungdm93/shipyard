FROM jupyter/scipy-notebook

LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"

USER root
SHELL [ "/bin/bash", "-c" ]
COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update -y; \
    apt-get install --no-install-recommends -y \
        gosu gnupg curl vim gettext-base tzdata openssh-client  \
        iproute2 net-tools telnet dnsutils iputils-* htop iftop \
        libsasl2-modules openjdk-8-jre-headless; \
    cleanup.sh apt;

ENV SPARK_VERSION=2.4.4  \
    HADOOP_VERSION=3.2.1 \
    SPARK_HOME=/opt/spark   \
    HADOOP_HOME=/opt/hadoop \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

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
    curl -L  "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"; \
    curl -L  "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz"; \
    tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" -C /opt; \
    rm  -rf  "hadoop-${HADOOP_VERSION}.tar.gz" "$HOME/.gnupg"; \
    mv  "/opt/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}";

RUN set -eux; \
    cd /tmp;  \
    curl -L  "${APACHE_DIST}/spark/KEYS" | gpg --batch --import -; \
    curl -LO "${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    curl -L  "${APACHE_DIST}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz.asc" | gpg --batch --verify - "spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    tar -xzf "spark-${SPARK_VERSION}-bin-without-hadoop.tgz" -C /opt; \
    rm  -rf  "spark-${SPARK_VERSION}-bin-without-hadoop.tgz" "$HOME/.gnupg"; \
    mv  "/opt/spark-${SPARK_VERSION}-bin-without-hadoop" "${SPARK_HOME}";

COPY ./configs/spark/*  ${SPARK_HOME}/conf/
COPY ./configs/hadoop/* ${HADOOP_HOME}/etc/hadoop/

ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip" \
    PATH="${SPARK_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"

USER $NB_UID

# Database drivers
RUN set -eux; \
    conda install -y \
        python-dotenv \
        boost pyarrow  \
        psycopg2        \
        mysqlclient     \
        pyodbc pymssql  \
        cx_oracle;      \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

# Widgets & visualization
RUN set -eux; \
    # ipywidgets
    conda install -y -c conda-forge ipywidgets; \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager; \
    \
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
