FROM jupyter/base-notebook:ubuntu-22.04
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
USER root
COPY ./scripts/ /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        curl vim gnupg bash-completion \
        tzdata dotnet-sdk-6.0; \
    cleanup.sh apt;

#### https://docs.microsoft.com/en-us/dotnet/core/install/linux
#### https://docs.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
# curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 6.0 --runtime dotnet
#### Using Package Manager
# source /etc/os-release
# curl -sSL "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmour -o /etc/apt/trusted.gpg.d/microsoft.gpg; \
# echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/ubuntu/${VERSION_ID}/prod ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/microsoft-prod.list; \
# apt update && apt install dotnet-runtime-6.0

# https://github.com/dotnet/interactive/blob/main/docs/NotebookswithJupyter.md
RUN set -eux; \
    dotnet tool install Microsoft.dotnet-interactive \
        --no-cache --tool-path "/usr/lib/dotnet/tools/"; \
    ln -s "/usr/lib/dotnet/tools/dotnet-interactive" "/usr/bin/dotnet-interactive"; \
    dotnet interactive jupyter install --path "${CONDA_DIR}/share/jupyter/kernels/"; \
    fix-permissions $CONDA_DIR; \
    cleanup.sh home node dotnet; \
    rm -rf /tmp/*;

USER $NB_UID
