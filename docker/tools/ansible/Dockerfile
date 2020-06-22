FROM hub.teko.vn/tools/deployer:base

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-wheel \
        python3-setuptools; \
    \
    ln -s /usr/bin/pip3 /usr/bin/pip; \
    pip config set --global global.no-cache-dir True; \
    pip completion --bash > /etc/bash_completion.d/pip; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN pip install \
        ansible \
        Jinja2  \
        toml    \
        PyYAML  \
        paramiko \
        argcomplete \
        apache-libcloud; \
    activate-global-python-argcomplete;

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
