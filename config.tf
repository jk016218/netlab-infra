variable "region" {
  type = string
  default = "West Europe"
}

# To avoid collisions, don't consume unnecessarily big chunks
variable "netlab_prefix" {
  type = string
  default = "10.73.86.0/24"
}

# We could need more than one subnet (or network, even) one day, so keeping things sparse and loose
variable "netlab_main_prefix" {
  type = string
  default = "10.73.86.128/26"  # 10.73.86.129-190
}

# SSH
variable "ssh_public_key" {
  type = string
  default = ""
}

# The "shell machine"
variable "shellmachine_private_ip_address" {
  type = string
  default = "10.73.86.150"
}

variable "shellmachine_username" {
  type = string
  default = "netlab"
}
