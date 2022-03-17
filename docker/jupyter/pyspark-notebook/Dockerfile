# patched: https://github.com/swan-cern/sparkmonitor/pull/6
FROM openjdk:8-slim AS sparkmonitor

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y curl gnupg2;

RUN set -eux; \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" \
        | apt-key add; \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" > /etc/apt/sources.list.d/sbt.list; \
    apt-get update; \
    apt-get install --no-install-recommends -y sbt;

WORKDIR /app/sparkmonitor
COPY ./patch/sparkmonitor /app/sparkmonitor
RUN sbt +assembly

FROM jupyter/scipy-notebook:python-3.9.7
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]
USER root

COPY ./scripts/ /usr/local/bin/
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        curl vim bash-completion gettext-base \
        tzdata gosu openssh-client libsasl2-modules \
        iproute2 net-tools telnet dnsutils iputils-* htop iftop \
        openjdk-8-jre-headless; \
    ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so; \
    ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so; \
    cleanup.sh apt;

USER $NB_UID

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    SPARK_HOME="/opt/spark"
ENV PATH="${SPARK_HOME}/bin:${PATH}" \
    LD_LIBRARY_PATH="${SPARK_HOME}/hadoop/lib/native:${LD_LIBRARY_PATH}"

COPY --chown=$NB_UID:$NB_GID --from=hub.teko.vn/dataops/spark:3.2.0 \
        /opt/spark  ${SPARK_HOME}
# Alternative solutions:
# export PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip"
RUN pip install --no-cache-dir -e "${SPARK_HOME}/python"

COPY --chown=$NB_UID:$NB_GID --from=sparkmonitor \
        /app/sparkmonitor/listener_2.12.jar "${SPARK_HOME}/jars/sparkmonitor_2.12.jar"
RUN pip install --no-cache-dir sparkmonitor

COPY --chown=$NB_UID:$NB_GID ./configs/ /opt/

RUN set -eux; \
    mamba install -c conda-forge -y \
        # xeus-python \
        jupyter-server-proxy \
        jupyter-lsp-python \
        jupyterlab-git; \
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
    fix-permissions $CONDA_DIR /home/$NB_USER; \
    rm -rf /opt/conda/cx_Oracle-doc;

# Widgets & visualization
RUN set -eux; \
    mamba install -c plotly -y \
        plotly; \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

# RUN set -eux; \
#     # ipywidgets ipyleaflet pythreejs bqplot
#     mamba install -c conda-forge -y \
#         ipyleaflet pythreejs bqplot; \
#     \
#     # plotly
#     mamba install -c plotly -y \
#         plotly plotly-geo python-kaleido; \
#     \
#     # altair
#     mamba install -c conda-forge -y \
#         altair; \
#     \
#     # jupyterlab-sidecar
#     mamba install -c conda-forge -y \
#         sidecar; \
#     \
#     cleanup.sh conda npm home; \
#     fix-permissions $CONDA_DIR /home/$NB_USER;