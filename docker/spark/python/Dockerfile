ARG BASE_IMAGE

FROM ubuntu:bionic AS builder

WORKDIR /build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates gnupg curl;

ARG CONDA_VERSION=4.7.12
ARG PYTHON_VERSION=3.7
ENV CONDA_HOME=/opt/conda

RUN curl -LO "https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh";
RUN set -eux; \
    bash "Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" -b -p "${CONDA_HOME}"; \
    echo "conda ${CONDA_VERSION}" >> "${CONDA_HOME}/conda-meta/pinned"; \
    \
    "${CONDA_HOME}/bin/conda" config --system --prepend channels conda-forge; \
    "${CONDA_HOME}/bin/conda" config --system --set auto_update_conda false; \
    "${CONDA_HOME}/bin/conda" config --system --set show_channel_urls true; \
    \
    "${CONDA_HOME}/bin/conda" install -y "python=${PYTHON_VERSION}"; \
    echo "$PYTHON_VERSION" | grep -oP '^\d+.\d+' | xargs -I% echo "python %.*" >> "${CONDA_HOME}/conda-meta/pinned"; \
    \
    "${CONDA_HOME}/bin/conda" clean -fay;



FROM ${BASE_IMAGE}

ENV CONDA_HOME=/opt/conda
COPY --from=builder ${CONDA_HOME} ${CONDA_HOME}

ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip" \
    PATH="${CONDA_HOME}/bin:${PATH}"
