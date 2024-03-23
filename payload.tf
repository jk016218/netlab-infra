resource "azurerm_network_interface" "payload" {
  count               = length(var.payload_private_ip_addresses)
  name                = "payload-${count.index}"
  location            = azurerm_resource_group.netlab.location
  resource_group_name = azurerm_resource_group.netlab.name

  ip_configuration {
    name                          = "payload-${count.index}"
    subnet_id                     = azurerm_subnet.netlab_payload.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.payload_private_ip_addresses[count.index]
  }
}

resource "azurerm_linux_virtual_machine" "payload" {
  count               = length(var.payload_private_ip_addresses)
  name                = "payload-${count.index}"
  resource_group_name = azurerm_resource_group.netlab.name
  location            = azurerm_resource_group.netlab.location
  size                = var.payload_kind
  admin_username      = var.payload_username
  network_interface_ids = [
    azurerm_network_interface.payload[count.index].id,
  ]

  admin_ssh_key {
    username   = var.payload_username
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

output "payload_public_ip_addresses" {
  value = azurerm_network_interface.payload[*].private_ip_address
}
