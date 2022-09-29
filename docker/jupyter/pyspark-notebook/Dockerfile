FROM jupyter/scipy-notebook:python-3.10.6
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
USER root
COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        curl vim gnupg gosu bash-completion gettext-base \
        libc6 libsasl2-modules \
        tzdata openjdk-8-jre-headless \
        # Hadoop native packages
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libssl3 libisal2 libnss3 libpam-modules krb5-user procps \
        # Spark native packages
        libopenblas-base libatlas3-base libarpack2; \
    cleanup.sh apt;
USER $NB_UID

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    SPARK_HOME="/opt/spark" \
    PATH="/opt/spark/bin:${PATH}" \
    LD_LIBRARY_PATH="/opt/spark/hadoop/lib/native:${LD_LIBRARY_PATH}" \
    PYARROW_IGNORE_TIMEZONE=1 \
    OPENBLAS_NUM_THREADS=1 \
    MKL_NUM_THREADS=1

COPY --chown=$NB_UID:$NB_GID --from=hub.teko.vn/dataops/spark:3.3.0 \
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
    cleanup.sh conda node home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;
