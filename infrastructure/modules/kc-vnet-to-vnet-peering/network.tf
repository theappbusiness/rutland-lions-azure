resource "azurerm_virtual_network_peering" "pri_sec" {
  name                      = "peer-${var.location_pri}-${var.location_sec}-${var.environment}"
  resource_group_name       = var.resource_group_name_pri
  virtual_network_name      = var.vnet_name_pri
  remote_virtual_network_id = var.vnet_id_sec
}

resource "azurerm_virtual_network_peering" "sec_pri" {
  name                      = "peer-${var.location_sec}-${var.location_pri}-${var.environment}"
  resource_group_name       = var.resource_group_name_sec
  virtual_network_name      = var.vnet_name_sec
  remote_virtual_network_id = var.vnet_id_pri
}
