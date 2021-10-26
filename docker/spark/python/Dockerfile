ARG BASE_IMAGE

FROM ubuntu:focal AS builder
SHELL [ "/bin/bash", "-c" ]

WORKDIR /build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates gnupg curl;

ARG CONDA_VERSION=4.10.3
ARG PYTHON_VERSION=3.9
ENV CONDA_HOME=/opt/conda

RUN curl -LO "https://repo.continuum.io/miniconda/Miniconda3-py${PYTHON_VERSION/./}_${CONDA_VERSION}-Linux-x86_64.sh";

RUN set -eux; \
    bash Miniconda3-*-Linux-x86_64.sh -b -p "${CONDA_HOME}"; \
    export PATH="${CONDA_HOME}/bin:${PATH}"; \
    \
    conda config --system --prepend channels conda-forge; \
    conda config --system --set auto_update_conda false; \
    conda config --system --set show_channel_urls true; \
    \
    echo "conda ${CONDA_VERSION}" >> "${CONDA_HOME}/conda-meta/pinned"; \
    echo "$PYTHON_VERSION" | grep -oP '^\d+.\d+' | xargs -I% echo "python %.*" >> "${CONDA_HOME}/conda-meta/pinned";


FROM ${BASE_IMAGE}

ENV CONDA_HOME=/opt/conda
COPY --from=builder ${CONDA_HOME} ${CONDA_HOME}

ENV PATH="${CONDA_HOME}/bin:${PATH}"

# Alternative solutions:
# export PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip"
RUN pip install --no-cache-dir -e "${SPARK_HOME}/python"

RUN set -eux; \
    conda install -c conda-forge -y \
        pyarrow; \
    conda clean -fay;
