FROM jupyter/scipy-notebook

LABEL maintainer="dungdm93"

USER root
SHELL [ "/bin/bash", "-c" ]
COPY ./scripts/ /usr/local/bin/

# ML tools: facets & What-If Tool
RUN set -eux; \
    pip install facets-overview witwidget; \
    jupyter labextension install wit-widget; \
    \
    cleanup.sh conda npm home; \
    fix-permissions $CONDA_DIR /home/$NB_USER;
