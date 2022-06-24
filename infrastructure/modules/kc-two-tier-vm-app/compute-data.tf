resource "azurerm_network_interface" "data" {
  name                = "vm-sql-${local.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.vnet_subnets["DataSubnet"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "data" {
  #checkov:skip=CKV_AZURE_50:   TODO: Disable VM extension operations
  #checkov:skip=CKV_AZURE_151:  TODO: Encryption
  name                  = "vm-sql-${local.resource_suffix}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  computer_name         = "${var.computer_name_prefix_data}${substr(md5("${var.environment}${var.location}"), 0, (15 - length("${var.computer_name_prefix_data}")))}"
  size                  = var.vm_size_data
  admin_username        = var.vm_admin_username
  admin_password        = random_password.vm_admin_password.result
  network_interface_ids = [azurerm_network_interface.data.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2022"
    sku       = "standard-gen2"
    version   = "latest"
  }

  tags = local.tags
}
