resource "azurerm_virtual_network" "netlab" {
  name                = "netlab"
  location            = azurerm_resource_group.netlab.location
  resource_group_name = azurerm_resource_group.netlab.name
  address_space       = [var.netlab_prefix]
}

resource "azurerm_subnet" "netlab_main" {
  name                 = "netlab_main"
  resource_group_name  = azurerm_resource_group.netlab.name
  virtual_network_name = azurerm_virtual_network.netlab.name
  address_prefixes     = [var.netlab_main_prefix]
}
