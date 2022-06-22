resource "random_password" "sql_administrator_password" {
  length           = 32
  special          = true
  override_special = "#&-_+"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_synapse_workspace" "example_synapse" {
  #checkov:skip=CKV_AZURE_58:   TODO: Data exfiltration and managed VNET
  #checkov:skip=CKV_AZURE_157:  TODO: Data exfiltration and managed VNET
  name                                 = "st-ex-syn-${var.environment}"
  resource_group_name                  = azurerm_resource_group.example_synapse.name
  location                             = azurerm_resource_group.example_synapse.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example_synapse.id
  sql_administrator_login              = var.synapse_sql_administrator_username
  sql_administrator_login_password     = random_password.sql_administrator_password.result

  dynamic "aad_admin" {
    for_each = var.synapse_sql_aad_administrator_enabled ? [1] : []

    content {
      login     = var.synapse_sql_aad_administrator_username
      object_id = var.synapse_sql_aad_administrator_object_id
      tenant_id = data.azurerm_client_config.current.tenant_id
    }
  }

  dynamic "github_repo" {
    for_each = var.synapse_github_repo_enabled ? [1] : []

    content {
      account_name    = var.synapse_github_repo_account_name
      branch_name     = var.synapse_github_repo_branch_name
      repository_name = var.synapse_github_repo_name
      root_folder     = var.synapse_github_repo_root_folder
    }
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "sql_aad_admin" {
    for_each = var.synapse_sql_aad_administrator_enabled ? [1] : []

    content {
      login     = var.synapse_sql_aad_administrator_username
      object_id = var.synapse_sql_aad_administrator_object_id
      tenant_id = data.azurerm_client_config.current.tenant_id
    }
  }

  tags = local.tags
}
