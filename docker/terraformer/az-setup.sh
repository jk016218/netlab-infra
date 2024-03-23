#!/bin/bash -e

az login
export ARM_SUBSCRIPTION_ID=$(az account list | jq -r '.[0].id')
echo "Working with subscription ${ARM_SUBSCRIPTION_ID}"
az account set --subscription $ARM_SUBSCRIPTION_ID
AZURE_SP=$(az ad sp create-for-rbac --role=Contributor "--scopes=/subscriptions/${ARM_SUBSCRIPTION_ID}")
export ARM_CLIENT_ID=$(echo $AZURE_SP | jq -r '.appId')
export ARM_CLIENT_SECRET=$(echo $AZURE_SP | jq -r '.password')
export ARM_TENANT_ID=$(echo $AZURE_SP | jq -r '.tenant')
export TF_VAR_ssh_public_key=$(ssh-add -L | grep ssh-rsa | head -1)

bash -i
