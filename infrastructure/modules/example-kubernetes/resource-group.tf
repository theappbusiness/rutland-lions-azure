resource "azurerm_resource_group" "example_kubernetes" {
  name     = "rg-ex-aks-${var.environment}"
  location = var.location

  tags = local.tags
}
