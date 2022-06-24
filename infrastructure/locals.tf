locals {
  care_environments = {
    dev = {
      vnet_base_cidr_block_pri = "10.70.0.0/24"
      vnet_base_cidr_block_sec = "10.170.0.0/24"
      vm_size_data             = "Standard_E2_v4"
      vm_size_web              = "Standard_D2_v4"
    }
    test = {
      vnet_base_cidr_block_pri = "10.80.0.0/24"
      vnet_base_cidr_block_sec = "10.180.0.0/24"
      vm_size_data             = "Standard_E4_v4"
      vm_size_web              = "Standard_D4_v4"
    }
    prod = {
      vnet_base_cidr_block_pri = "10.90.0.0/24"
      vnet_base_cidr_block_sec = "10.190.0.0/24"
      vm_size_data             = "Standard_E4_v4"
      vm_size_web              = "Standard_D4_v4"
    }
  }

  resource_suffix_pri = "${local.workload_short}-${terraform.workspace}-${module.azure_region_pri.location_short}"

  tags = {
    CreatedBy   = "terraform"
    CostCentre  = "G10032"
    Environment = terraform.workspace
    Workload    = local.workload_name
  }

  workload_name  = "care"
  workload_short = "care"
}
