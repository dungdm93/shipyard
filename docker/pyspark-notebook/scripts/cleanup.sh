#!/bin/bash
set -e

cleanup-apt() {
    apt-get clean
    rm -rfv /var/lib/apt/lists/*
}

cleanup-conda() {
    conda clean --all --yes
    # find $CONDA_DIR -type f -name '*.py[co]'    -delete \
    #              -o -type d -name '__pycache__' -delete
    rm -rfv $CONDA_DIR/share/jupyter/lab/staging
}

cleanup-npm() {
    npm cache clean --force
    rm -rfv /home/$NB_USER/.node-gyp
}

cleanup-home() {
    rm -rfv \
        /home/$NB_USER/.cache   \
        /home/$NB_USER/.empty
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
