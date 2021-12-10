#!/bin/bash
set -e

cleanup-apt() {
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}

cleanup-conda() {
    conda clean -fay
    # find $CONDA_DIR -type f -name '*.py[co]'    -delete \
    #              -o -type d -name '__pycache__' -delete
    rm -rf $CONDA_DIR/share/jupyter/lab/staging
}

cleanup-npm() {
    npm cache clean --force
    rm -rf \
        /home/$NB_USER/.npm     \
        /home/$NB_USER/.yarn    \
        /home/$NB_USER/.node-gyp
}

cleanup-home() {
    rm -rf \
        /home/$NB_USER/.cache   \
        /home/$NB_USER/.empty   \
        /home/$NB_USER/.npm     \
        /home/$NB_USER/.yarn    \
        /home/$NB_USER/.node-gyp
}

for type in "$@"; do
    case $type in
        apt)
            cleanup-apt
            ;;
        conda)
            cleanup-conda
            ;;
        npm)
            cleanup-npm
            ;;
        home)
            cleanup-home
            ;;
        *)
            cleanup-apt
            cleanup-conda
            cleanup-npm
            cleanup-home
            ;;
    esac
done
