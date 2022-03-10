# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.224.2/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT="hirsute"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Install Packer
ARG PACKER_VERSION="1.8.0"
ARG PACKER_ARCH="amd64"
RUN set -x \
 && TMPDIR=$(mktemp -d) \
 && cd $TMPDIR \
 && curl -fsSLo packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${PACKER_ARCH}.zip \
 && unzip packer.zip \
 && install packer /usr/local/bin \
 && rm -rf $TMPDIR