module "azure_region_pri" {
  source  = "claranet/regions/azurerm"
  version = "5.1.0"

  azure_region = var.location_pri
}

module "azure_region_sec" {
  source  = "claranet/regions/azurerm"
  version = "5.1.0"

  azure_region = var.location_sec
}
