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

module "care_peerings" {
  source = "./modules/kc-vnet-to-vnet-peering"

  environment             = terraform.workspace
  location_pri            = module.azure_region_pri.location_short
  location_sec            = module.azure_region_sec.location_short
  resource_group_name_pri = azurerm_resource_group.care_pri.name
  resource_group_name_sec = azurerm_resource_group.care_sec.name
  vnet_id_pri             = module.care_pri_common.vnet_id
  vnet_id_sec             = module.care_sec_common.vnet_id
  vnet_name_pri           = module.care_pri_common.vnet_name
  vnet_name_sec           = module.care_sec_common.vnet_name
}

module "care_pri_compute" {
  source = "./modules/kc-two-tier-vm-app"

  computer_name_prefix_web = "careweb"
  environment              = terraform.workspace
  location                 = module.azure_region_pri.location_cli
  resource_group_name      = azurerm_resource_group.care_pri.name
  resource_suffix          = local.resource_suffix_pri
  tags                     = local.tags

  vnet_subnets = module.care_pri_common.vnet_subnets
  vm_size_data = local.care_environments[terraform.workspace].vm_size_data
  vm_size_web  = local.care_environments[terraform.workspace].vm_size_web
}

module "care_sec_compute" {
  source = "./modules/kc-two-tier-vm-app"

  computer_name_prefix_web = "careweb"
  environment              = terraform.workspace
  location                 = module.azure_region_sec.location_cli
  resource_group_name      = azurerm_resource_group.care_sec.name
  resource_suffix          = local.resource_suffix_sec
  tags                     = local.tags

  vnet_subnets = module.care_sec_common.vnet_subnets
  vm_size_data = local.care_environments[terraform.workspace].vm_size_data
  vm_size_web  = local.care_environments[terraform.workspace].vm_size_web
}
