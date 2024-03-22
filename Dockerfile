FROM ubuntu:22.04

ENV ARM_SUBSCRIPTION_ID 06b0ab03-5ae9-459a-bdd6-78a5caf206f0

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

# Log in to Azure
RUN az login \
    && export ARM_SUBSCRIPTION_ID=$(az account list | jq -r '.[0].id') \
    && echo "Working with subscription ${ARM_SUBSCRIPTION_ID}" \
    && az account set --subscription $ARM_SUBSCRIPTION_ID \
    && AZURE_SP=$(az ad sp create-for-rbac --role=Contributor "--scopes=/subscriptions/${ARM_SUBSCRIPTION_ID}") \
    && export ARM_CLIENT_ID=$(echo $AZURE_SP | jq -r '.appId') \
    && export ARM_CLIENT_SECRET=$(echo $AZURE_SP | jq -r '.password') \
    && export ARM_TENANT_ID=$(echo $AZURE_SP | jq -r '.tenant')

WORKDIR /workdir
