ARG  PYSPARK_SOURCE_IMAGE
FROM ${PYSPARK_SOURCE_IMAGE} AS source

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

COPY --chown=$NB_UID:$NB_GID --from=source       /opt/hadoop ${HADOOP_HOME}
COPY --chown=$NB_UID:$NB_GID --from=source       /opt/spark  ${SPARK_HOME}
COPY --chown=$NB_UID:$NB_GID ./configs/jupyter/* ${CONDA_DIR}/etc/jupyter

ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip" \
    PATH="${SPARK_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"

# Database drivers
RUN set -eux; \
    conda install -y \
        python-dotenv \
        papermill     \
        boost         \
        psycopg2      \
        mysqlclient   \
        pyodbc        \
        cx_oracle;    \
    pip install --no-cache-dir \
        pyarrow==0.15.*; \
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
