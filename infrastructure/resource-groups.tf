resource "azurerm_resource_group" "care_pri" {
  name     = "rg-${local.resource_suffix_pri}"
  location = module.azure_region_pri.location_cli
}
