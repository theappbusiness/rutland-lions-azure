resource "azurerm_container_registry" "example_app_service" {
  #checkov:skip=CKV_AZURE_137: Admin account in-use for demo
  #checkov:skip=CKV_AZURE_139: Disabling public networking only available for Premium SKU
  name                = replace("acr-ex-app-service-${var.environment}", "-", "")
  resource_group_name = azurerm_resource_group.example_app_service.name
  location            = azurerm_resource_group.example_app_service.location
  sku                 = var.container_registry_sku
  admin_enabled       = true

  dynamic "georeplications" {
    for_each = var.container_registry_sku == "Premium" ? [1] : []

    content {
      location                = var.location_secondary
      zone_redundancy_enabled = true

      tags = local.tags
    }
  }

  tags = local.tags
}
