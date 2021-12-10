ARG  SOURCE_IMAGE
FROM ${SOURCE_IMAGE} AS source

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y openjdk-8-jdk-headless;

COPY ./patches/ /patches/org/apache/spark/ui/static/

RUN set -eux; cd /patches/; \
    jar -uf ${SPARK_HOME}/jars/spark-core_*.jar org/

FROM jupyter/scipy-notebook:python-3.9.6
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]
USER root

COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        gosu curl vim gettext-base tzdata openssh-client libsasl2-modules \
        iproute2 net-tools telnet dnsutils iputils-* htop iftop \
        openjdk-8-jre-headless; \
    ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so; \
    ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so; \
    cleanup.sh apt;

USER $NB_UID

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    SPARK_HOME="/opt/spark"

COPY --chown=$NB_UID:$NB_GID --from=source       /opt/spark  ${SPARK_HOME}
COPY --chown=$NB_UID:$NB_GID ./configs/jupyter/* ${CONDA_DIR}/etc/jupyter

ENV PATH="${SPARK_HOME}/bin:${PATH}" \
    LD_LIBRARY_PATH="${SPARK_HOME}/hadoop/lib/native:${LD_LIBRARY_PATH}"

# Alternative solutions:
# export PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip"
RUN pip install --no-cache-dir -e "${SPARK_HOME}/python"

RUN set -eux; \
    mamba install -c conda-forge -y \
        xeus-python \
        jupyter-server-proxy \
        jupyterlab-git \
        jupyterlab-lsp \
        python-lsp-server; \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

# Database drivers
RUN set -eux; \
    mamba install -y \
        python-dotenv \
        papermill     \
        boost         \
        pyarrow       \
        psycopg2      \
        mysqlclient   \
        pyodbc        \
        cx_oracle;    \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

# Widgets & visualization
# RUN set -eux; \
#     # ipywidgets ipyleaflet pythreejs bqplot
#     mamba install -y -c conda-forge \
#         ipyleaflet pythreejs bqplot; \
#     jupyter labextension install \
#         jupyter-leaflet jupyter-threejs bqplot; \
#     \
#     # plotly
#     mamba install -y -c plotly \
#         plotly plotly-orca plotly-geo psutil requests; \
#     jupyter labextension install jupyterlab-plotly plotlywidget; \
#     \
#     # altair
#     mamba install -y -c conda-forge altair; \
#     \
#     # jupyterlab-sidecar
#     pip install sidecar; \
#     jupyter labextension install @jupyter-widgets/jupyterlab-sidecar; \
#     \
#     cleanup.sh conda npm home; \
#     fix-permissions $CONDA_DIR /home/$NB_USER;
