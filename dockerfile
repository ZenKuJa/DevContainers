FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    git \
    build-essential \
    openjdk-21-jdk \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN useradd -m -s /bin/bash javaDev \
    && usermod -aG sudo javaDev \
    && usermod -aG docker javaDev \
    && echo "javaDev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/javadev-nopasswd

USER javaDev
WORKDIR /home/javaDev
RUN code-server --install-extension vscjava.vscode-java-pack && \
    code-server --install-extension vmware.vscode-boot-dev-pack && \
    code-server --install-extension vscode-icons-team.vscode-icons && \
    code-server --install-extension mechatroner.rainbow-csv && \
    code-server --install-extension oderwat.indent-rainbow && \
    code-server --install-extension shardulm94.trailing-spaces\
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension eamodio.gitlens && \
    code-server --install-extension formulahendry.code-runner && \
    code-server --install-extension redhat.vscode-yaml

EXPOSE 8080

CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]