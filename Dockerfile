FROM ubuntu:22.04

RUN apt update \
    && apt install -y curl

# Latest versions:

# Terraform
RUN apt install -y gnupg software-properties-common \
    && curl https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update \
    && apt install -y terraform

# Azure CLI
RUN apt install -y ca-certificates apt-transport-https lsb-release \
    && mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /etc/apt/keyrings/microsoft.gpg \
    && chmod go+r /etc/apt/keyrings/microsoft.gpg

RUN echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt update \
    && apt install -y azure-cli

# jq
RUN apt install -y jq

COPY ./docker/terraformer/az-setup.sh /usr/local/bin/

WORKDIR /workdir
