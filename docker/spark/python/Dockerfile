ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        gnupg curl; \
    rm -rf /var/cache/apt/*;

ENV CONDA_VERSION=4.7.12 \
    PYTHON_VERSION=3.7   \
    CONDA_HOME=/opt/conda

RUN set -eux; \
    cd /tmp;  \
    curl -LO "https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
    bash     "Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" -b -p "${CONDA_HOME}"; \
    rm  -rf  "Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
    \
    echo "conda ${CONDA_VERSION}" >> "${CONDA_HOME}/conda-meta/pinned"; \
    "${CONDA_HOME}/bin/conda" config --system --prepend channels conda-forge; \
    "${CONDA_HOME}/bin/conda" config --system --set auto_update_conda false; \
    "${CONDA_HOME}/bin/conda" config --system --set show_channel_urls true; \
    \
    "${CONDA_HOME}/bin/conda" install -y "python=${PYTHON_VERSION}"; \
    "${CONDA_HOME}/bin/conda" clean -fay;

ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip" \
    PATH="${CONDA_HOME}/bin:${PATH}"
