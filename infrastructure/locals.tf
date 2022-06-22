locals {
  landing_zone_environments = {
    dev = {
      vnet_base_cidr_block = "10.70.0.0/24"
    }
    test = {
      vnet_base_cidr_block = "10.80.0.0/24"
    }
    prod = {
      vnet_base_cidr_block = "10.90.0.0/24"
    }
  }

  resource_suffix = "${local.workload_short}-${terraform.workspace}-${module.azure_region.location_short}"
  workload_name   = "landing-zone"
  workload_short  = "lz"
}
