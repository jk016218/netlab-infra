# netlab-infra

tldr; Install at least
[Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli),
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt),
and
[jq](https://jqlang.github.io/jq/download/).



```console
# In an attempt to avoid unnecessary confusion, pick subscription manually. Your's will likely look different:
az login
ARM_SUBSCRIPTION_ID=06b0ab03-5ae9-459a-bdd6-78a5caf206f0  # Pick one from previous command's output

# Lay credentials out for Terraform's consumption
az account set --subscription $ARM_SUBSCRIPTION_ID
AZURE_SP=$(az ad sp create-for-rbac --role=Contributor "--scopes=/subscriptions/${ARM_SUBSCRIPTION_ID}")
export ARM_CLIENT_ID=$(echo $AZURE_SP | jq -r '.appId')
export ARM_CLIENT_SECRET=$(echo $AZURE_SP | jq -r '.password')
export ARM_TENANT_ID=$(echo $AZURE_SP | jq -r '.tenant')


```
