resource "azurerm_resource_group" "care_pri" {
  name     = "rg-${local.resource_suffix_pri}"
  location = module.azure_region_pri.location_cli
}

resource "azurerm_resource_group" "care_sec" {
  name     = "rg-${local.resource_suffix_sec}"
  location = module.azure_region_sec.location_cli
}
