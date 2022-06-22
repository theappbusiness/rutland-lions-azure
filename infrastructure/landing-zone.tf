module "landing_zone_common" {
  source = "./modules/landing-zone-common"

  environment     = terraform.workspace
  location        = module.azure_region.location_cli
  resource_suffix = local.resource_suffix

  tags = {
    CreatedBy   = "terraform"
    Environment = terraform.workspace
    Workload    = local.workload_name
  }

  vnet_base_cidr_block = local.landing_zone_environments[terraform.workspace].vnet_base_cidr_block
  vnet_subnets = [
    {
      name     = "T1Subnet"
      new_bits = 1
    }
  ]
}
