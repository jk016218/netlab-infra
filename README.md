# netlab-infra

tldr; Install at least
[Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli),
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt),
and
[jq](https://jqlang.github.io/jq/download/).

In order to keep things streamlined and hassle at a minimum,
[state](https://developer.hashicorp.com/terraform/language/state)
is local.

For details about the `ARM_*` environment variable below, do check out
["Authenticate Terraform to Azure"](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#2-authenticate-terraform-to-azure).

```console
# To avoid unnecessary confusion, pick a subscription manually. Your's will likely look different:
az login
az account list
export ARM_SUBSCRIPTION_ID=06b0ab03-5ae9-459a-bdd6-78a5caf206f0  # Pick correct `id` from previous command's output (whatever "correct" means)

# Lay credentials out for Terraform's consumption
az account set --subscription $ARM_SUBSCRIPTION_ID
AZURE_SP=$(az ad sp create-for-rbac --role=Contributor "--scopes=/subscriptions/${ARM_SUBSCRIPTION_ID}")
export ARM_CLIENT_ID=$(echo $AZURE_SP | jq -r '.appId')
export ARM_CLIENT_SECRET=$(echo $AZURE_SP | jq -r '.password')
export ARM_TENANT_ID=$(echo $AZURE_SP | jq -r '.tenant')

# An SSH key for logging into machines in the "netlab" network.
# Azure requires that this is of the `ssh-keygen -t rsa` kind.
export TF_VAR_ssh_public_key=$(ssh-keygen -f /path/to/private/key -y)

# If there's a need to debug things, declare e.g. `TF_LOG=debug terraform init`;
# check out https://developer.hashicorp.com/terraform/internals/debugging for further details.
terraform init
terraform plan
terraform apply
```
