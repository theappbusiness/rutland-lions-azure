module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.vnet_base_cidr_block
  networks        = var.vnet_subnets
}

resource "azurerm_virtual_network" "landing_zone" {
  name                = "vnet-${local.resource_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
  address_space       = [var.vnet_base_cidr_block]

  tags = local.tags
}

resource "azurerm_subnet" "landing_zone" {
  for_each = module.subnets.network_cidr_blocks

  name                 = each.key
  resource_group_name  = azurerm_resource_group.landing_zone.name
  address_prefixes     = [each.value]
  virtual_network_name = azurerm_virtual_network.landing_zone.name
}
