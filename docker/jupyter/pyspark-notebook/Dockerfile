FROM jupyter/scipy-notebook:python-3.9.12
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
        # Hadoop native packages
        openjdk-8-jre-headless ca-certificates libc6 \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libssl1.1 libisal2 libnss3 libpam-modules krb5-user procps \
        # Spark native packages
        libopenblas-base libatlas3-base libarpack2; \
    ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so; \
    ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so; \
    cleanup.sh apt;
USER $NB_UID

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    SPARK_HOME="/opt/spark" \
    PATH="/opt/spark/bin:${PATH}" \
    LD_LIBRARY_PATH="/opt/spark/hadoop/lib/native:${LD_LIBRARY_PATH}" \
    PYARROW_IGNORE_TIMEZONE=1 \
    OPENBLAS_NUM_THREADS=1 \
    MKL_NUM_THREADS=1

COPY --chown=$NB_UID:$NB_GID --from=hub.teko.vn/dataops/spark:3.2.1 \
        /opt/spark  ${SPARK_HOME}
RUN pip install --no-cache-dir -e "${SPARK_HOME}/python"
# Alternative solutions:
# export PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip"

RUN set -eux; \
    mamba install -c conda-forge --no-update-deps -y \
        # xeus-python \
        jupyter-server-proxy \
        jupyter-lsp-python \
        jupyterlab-git \
        python-dotenv \
        papermill \
        pyarrow \
        pandas \
        numpy \
        plotly; \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;

COPY --chown=$NB_UID:$NB_GID ./configs/ /opt/

# RUN set -eux; \
#     pip install --no-cache-dir sparkmonitor; \
#     ln -s "$CONDA_DIR/lib/python3.9/site-packages/sparkmonitor/listener_2.12.jar" \
#           "$SPARK_HOME/jars/sparkmonitor_2.12.jar";

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
