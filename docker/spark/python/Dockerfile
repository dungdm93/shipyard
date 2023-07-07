ARG BASE_IMAGE

FROM ubuntu:jammy AS builder
SHELL [ "/bin/bash", "-c" ]

WORKDIR /build
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates gnupg curl;

ARG CONDA_VERSION=23.3.1 \
    PYTHON_VERSION=3.10
ENV CONDA_HOME="/opt/conda" \
    PATH="/opt/conda/bin:${PATH}"

RUN curl -LO "https://repo.anaconda.com/miniconda/Miniconda3-py${PYTHON_VERSION/./}_${CONDA_VERSION}-0-Linux-x86_64.sh";

RUN set -eux; \
    bash Miniconda3-*-Linux-x86_64.sh -b -p "${CONDA_HOME}"; \
    conda clean -fay;

RUN set -eux; \
    conda config --system --prepend channels conda-forge; \
    conda config --system --set auto_update_conda false; \
    conda config --system --set show_channel_urls true; \
    \
    conda --version >> "${CONDA_HOME}/conda-meta/pinned"; \
    echo "$PYTHON_VERSION" | grep -oP '^\d+.\d+' | xargs -I% echo "python %.*" >> "${CONDA_HOME}/conda-meta/pinned";

RUN --mount=type=cache,target=${CONDA_HOME}/pkgs,sharing=locked \
    conda install -n base -c conda-forge --no-update-deps -y \
        mamba;

RUN --mount=type=cache,target=${CONDA_HOME}/pkgs,sharing=locked \
    mamba install -c conda-forge --no-update-deps -y \
        numpy \
        pandas \
        pyarrow;

FROM ${BASE_IMAGE}

ENV CONDA_HOME="/opt/conda" \
    PATH="/opt/conda/bin:${PATH}" \
    PYARROW_IGNORE_TIMEZONE=1

COPY --link --from=builder ${CONDA_HOME} ${CONDA_HOME}

# Alternative solutions:
# export PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip"
RUN pip install --no-cache-dir -e "${SPARK_HOME}/python"
