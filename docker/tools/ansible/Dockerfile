FROM ghcr.io/dungdm93/tools/base:2.0

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-wheel \
        python3-setuptools; \
    \
    pip config set --global global.no-cache-dir True; \
    pip completion --bash > /etc/bash_completion.d/pip; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ARG ANSIBLE_VERSION=6.5.*

RUN pip install ansible==${ANSIBLE_VERSION} \
        Jinja2  \
        toml    \
        PyYAML  \
        paramiko \
        argcomplete \
        apache-libcloud; \
    activate-global-python-argcomplete;

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
