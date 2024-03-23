variable "region" {
  type = string
  default = "swedencentral"
}

# To avoid collisions, don't consume unnecessarily big chunks and keep things sparse and loose
variable "netlab_prefix" {
  type = string
  default = "10.73.86.0/24"
}

variable "netlab_main_prefix" {
  type = string
  default = "10.73.86.0/26"  # 10.73.86.1-62
}

variable "netlab_payload_prefix" {
  type = string
  default = "10.73.86.128/26"  # 10.73.86.129-190
}

# SSH
variable "ssh_public_key" {
  type = string
  default = ""
}

# The "shell" machine
variable "shellmachine_kind" {
  type = string
  default = "Standard_B1s"
}

variable "shellmachine_private_ip_address" {
  type = string
  default = "10.73.86.10"
}

variable "shellmachine_username" {
  type = string
  default = "netlab"
}

# The "payload" machines
variable "payload_kind" {
  type = string
  default = "Standard_B1s"
}

variable "payload_private_ip_addresses" {
  type = list
  default = ["10.73.86.150", "10.73.86.151", "10.73.86.152"]  # FIXME make this and other addressing stuff more dynamic
}

variable "payload_username" {
  type = string
  default = "netlab"
}
