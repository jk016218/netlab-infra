provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "netlab" {
  name     = "netlab"
  location = var.region
}
