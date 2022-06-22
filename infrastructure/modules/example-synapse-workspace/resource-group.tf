resource "azurerm_resource_group" "example_synapse" {
  name     = "rg-ex-syn-${var.environment}"
  location = var.location

  tags = local.tags
}
