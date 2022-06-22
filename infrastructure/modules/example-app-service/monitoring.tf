resource "azurerm_application_insights" "example_app_service" {
  name                = "api-ex-app-service-${var.environment}"
  resource_group_name = azurerm_resource_group.example_app_service.name
  location            = azurerm_resource_group.example_app_service.location
  application_type    = var.app_service_type
  retention_in_days   = var.app_insights_retention_days

  tags = local.tags
}
