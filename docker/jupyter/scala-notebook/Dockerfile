FROM jupyter/base-notebook:ubuntu-22.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
USER root
COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        curl vim bash-completion \
        tzdata openjdk-8-jre-headless; \
    cleanup.sh apt;

RUN set -eux; \
    curl -sSL https://git.io/coursier-cli -o /usr/local/bin/coursier; \
    chmod +x /usr/local/bin/coursier

ARG SCALA_VERSION=2.12

RUN set -eux; \
    coursier bootstrap --fork almond --scala ${SCALA_VERSION} -- --install --global; \
    # Remove cache, auto download at first launch
    rm -rf ${COURSIER_CACHE:-~/.cache/coursier/}

USER $NB_UID
