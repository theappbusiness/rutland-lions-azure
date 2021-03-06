module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.vnet_base_cidr_block
  networks        = var.vnet_subnets
}

resource "azurerm_virtual_network" "care" {
  name                = "vnet-${local.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_base_cidr_block]

  tags = local.tags
}

resource "azurerm_subnet" "care" {
  for_each = module.subnets.network_cidr_blocks

  name                 = each.key
  resource_group_name  = var.resource_group_name
  address_prefixes     = [each.value]
  virtual_network_name = azurerm_virtual_network.care.name
}

resource "azurerm_network_watcher" "care" {
  name                = "nw-${var.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
}
