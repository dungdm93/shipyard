FROM jupyter/base-notebook:ubuntu-22.04
LABEL maintainer="dungdm93"
USER root
COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        curl vim bash-completion \
        tzdata openjdk-8-jre-headless; \
    cleanup.sh apt;
USER $NB_UID

RUN set -eux; \
    mamba install -c jetbrains --no-update-deps -y kotlin-jupyter-kernel; \
    cleanup.sh conda; \
    fix-permissions $CONDA_DIR;
