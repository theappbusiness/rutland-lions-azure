resource "azurerm_resource_group" "example_app_service" {
  name     = "rg-ex-app-service-${var.environment}"
  location = var.location

  tags = local.tags
}
