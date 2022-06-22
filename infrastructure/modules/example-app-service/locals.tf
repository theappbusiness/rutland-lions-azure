locals {
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.example_app_service.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.example_app_service.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    DOCKER_REGISTRY_SERVER_PASSWORD            = azurerm_container_registry.example_app_service.admin_password
    DOCKER_REGISTRY_SERVER_URL                 = azurerm_container_registry.example_app_service.login_server
    DOCKER_REGISTRY_SERVER_USERNAME            = azurerm_container_registry.example_app_service.admin_username
    KEY_VAULT_SECRET_SETTING                   = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.example_app_service.vault_uri}secrets/${azurerm_key_vault_secret.example_app_service.name}/)"
    XDT_MicrosoftApplicationInsights_Mode      = "default"
  }

  module_name = "example-app-service"

  tags = merge(
    var.tags,
    {
      Module = local.module_name
    }
  )
}
