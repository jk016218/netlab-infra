resource "azurerm_public_ip" "shellmachine" {
  name                = "shellmachine"
  resource_group_name = azurerm_resource_group.netlab.name
  location            = azurerm_resource_group.netlab.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "shellmachine" {
  name                = "shellmachine"
  location            = azurerm_resource_group.netlab.location
  resource_group_name = azurerm_resource_group.netlab.name

  ip_configuration {
    name                          = "shellmachine"
    subnet_id                     = azurerm_subnet.netlab_main.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.shellmachine_private_ip_address
    public_ip_address_id          = azurerm_public_ip.shellmachine.id
  }
}

resource "azurerm_linux_virtual_machine" "shellmachine" {
  name                = "shellmachine"
  resource_group_name = azurerm_resource_group.netlab.name
  location            = azurerm_resource_group.netlab.location
  size                = var.shellmachine_kind
  admin_username      = var.shellmachine_username
  network_interface_ids = [
    azurerm_network_interface.shellmachine.id,
  ]

  admin_ssh_key {
    username   = var.shellmachine_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "shellmachine_public_ip_address" {
  value = azurerm_public_ip.shellmachine.ip_address
}
