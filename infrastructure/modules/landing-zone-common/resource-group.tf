resource "azurerm_resource_group" "landing_zone" {
  name     = "rg-${local.resource_suffix}"
  location = var.location
}
