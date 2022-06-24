module "care_pri_common" {
  source = "./modules/kc-common-vnet"

  environment         = terraform.workspace
  location            = module.azure_region_pri.location_cli
  resource_group_name = azurerm_resource_group.care_pri.name
  resource_suffix     = local.resource_suffix_pri
  tags                = local.tags

  vnet_base_cidr_block = local.care_environments[terraform.workspace].vnet_base_cidr_block_pri
  vnet_subnets = [
    {
      name     = "WebSubnet"
      new_bits = 1
    },
    {
      name     = "DataSubnet"
      new_bits = 1
    }
  ]
}

module "care_sec_common" {
  source = "./modules/kc-common-vnet"

  environment         = terraform.workspace
  location            = module.azure_region_sec.location_cli
  resource_group_name = azurerm_resource_group.care_sec.name
  resource_suffix     = local.resource_suffix_sec
  tags                = local.tags

  vnet_base_cidr_block = local.care_environments[terraform.workspace].vnet_base_cidr_block_sec
  vnet_subnets = [
    {
      name     = "WebSubnet"
      new_bits = 1
    },
    {
      name     = "DataSubnet"
      new_bits = 1
    }
  ]
}
