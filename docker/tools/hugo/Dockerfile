FROM hub.teko.vn/tools/base:1.0

ENV HUGO_VERSION=v0.74.2
RUN set -eux; \
    cd /usr/local/bin/; \
    curl -sSL "https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_extended_${HUGO_VERSION#v}_Linux-64bit.tar.gz" \
        | tar -xzvf - hugo; \
    hugo gen autocomplete;

RUN set -eux; \
    curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
    apt-get install -y nodejs; \
    node --completion-bash > /etc/bash_completion.d/node; \
    # https://docs.npmjs.com/cli-commands/completion.html
    npm completion > /etc/bash_completion.d/npm; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g postcss-cli;
