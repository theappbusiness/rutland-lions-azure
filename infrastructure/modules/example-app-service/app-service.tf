resource "azurerm_service_plan" "example_app_service" {
  name                = "asp-ex-app-service-${var.environment}"
  resource_group_name = azurerm_resource_group.example_app_service.name
  location            = azurerm_resource_group.example_app_service.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku

  tags = local.tags
}

resource "azurerm_linux_web_app" "example_app_service" {
  name                = "app-ex-app-service-${var.environment}"
  resource_group_name = azurerm_resource_group.example_app_service.name
  location            = azurerm_resource_group.example_app_service.location
  service_plan_id     = azurerm_service_plan.example_app_service.id
  app_settings        = merge(local.app_settings, var.app_settings)
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 1
        retention_in_mb   = 25
      }
    }
  }

  site_config {
    always_on           = true
    ftps_state          = "Disabled"
    http2_enabled       = true
    minimum_tls_version = "1.2"

    dynamic "application_stack" {
      for_each = var.container_image_name != null ? [1] : []

      content {
        docker_image     = "${azurerm_container_registry.example_app_service.login_server}/${var.container_image_name}"
        docker_image_tag = var.container_image_tag
      }
    }
  }

  lifecycle {
    ignore_changes = [
      site_config["application_stack"]
    ]
  }

  tags = local.tags
}

resource "azurerm_app_service_certificate" "example_app_service" {
  count = var.custom_hostname != null ? 1 : 0

  name                = var.custom_hostname
  resource_group_name = azurerm_resource_group.example_app_service.name
  location            = azurerm_resource_group.example_app_service.location
  key_vault_secret_id = var.custom_hostname_certificate_secret_id

  tags = var.tags
}

resource "azurerm_app_service_custom_hostname_binding" "example_app_service" {
  count = var.custom_hostname != null ? 1 : 0

  hostname            = var.custom_hostname
  app_service_name    = azurerm_linux_web_app.example_app_service.name
  resource_group_name = azurerm_resource_group.example_app_service.name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.example_app_service[0].thumbprint
}
