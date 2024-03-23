# netlab-infra

tldr; Work with the [supplied Dockerfile](./Dockerfile):

FIXME verify that this works 100% of the time

```console
docker build --tag netlab-terraformer .

# SSH agent should be running, and have the "correct" key of `ssh-keygen -t rsa` kind loaded.
# The az-setup.sh script uses the first "ssh-rsa" key listed in `ssh-add -L`'s output.
export DOCKER_SSHAGENT="-v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK"
docker run --rm -it -v ${PWD}:/workdir $(echo $DOCKER_SSHAGENT) netlab-terraformer
```

Then, inside `netlab-terraformer` container:

```console
az-setup.sh

terraform init
terraform plan
terraform apply
```

Or, skipping Docker and doing it manually:

Install at least
[Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli),
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt),
and
[jq](https://jqlang.github.io/jq/download/).

In order to keep things streamlined and hassle at a minimum,
[state](https://developer.hashicorp.com/terraform/language/state)
is local.

For details about the `ARM_*` environment variables below, do check out
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

Once resources have been created, access to a "shell machine" in the `netlab` net can be gained by first
looking up its IP address, `shellmachine_public_ip_address`, in Terraform's outputs:

```console
terraform output
```

Then (and private key's path must match what was specified in `TF_VAR_ssh_public_key` above;
also the IPv4 address is almost certainly something else):

```console
ssh -i /path/to/private/key netlab@4.223.88.106
```
