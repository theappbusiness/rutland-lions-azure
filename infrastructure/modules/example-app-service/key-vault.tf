resource "azurerm_key_vault" "example_app_service" {
  #checkov:skip=CKV_AZURE_109: Firewall not implemented for demo
  name                        = replace("kv-ex-app-service-${var.environment}", "-", "")
  resource_group_name         = azurerm_resource_group.example_app_service.name
  location                    = azurerm_resource_group.example_app_service.location
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  sku_name                    = var.key_vault_sku
  soft_delete_retention_days  = 7
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.example_app_service.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  certificate_permissions = ["Create", "Delete", "Get", "Import", "List", "Purge", "Recover", "Update"]
  key_permissions         = ["Create", "Delete", "Get", "List", "Purge", "Recover"]
  secret_permissions      = ["Delete", "Get", "List", "Set", "Purge", "Recover"]
  storage_permissions     = ["Delete", "Get", "List", "Set", "Purge", "Recover"]
}

resource "azurerm_key_vault_access_policy" "app_service" {
  count = var.custom_hostname != null ? 1 : 0

  key_vault_id = azurerm_key_vault.example_app_service.id
  object_id    = var.app_service_principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  certificate_permissions = ["Get"]
  key_permissions         = []
  secret_permissions      = ["Get"]
  storage_permissions     = []
}

resource "azurerm_key_vault_access_policy" "example_app_service" {
  key_vault_id = azurerm_key_vault.example_app_service.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.example_app_service.identity.0.principal_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions      = ["Get"]
  storage_permissions     = []
}

resource "azurerm_key_vault_secret" "example_app_service" {
  #checkov:skip=CKV_AZURE_41: Secret rotation not implemented for demo
  #checkov:skip=CKV_AZURE_114: Content type unecessary due to manual update in portal
  key_vault_id = azurerm_key_vault.example_app_service.id
  name         = "example-app-service-secret-setting"
  value        = "<enter_value>"

  depends_on = [
    azurerm_key_vault_access_policy.terraform
  ]

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = local.tags
}
