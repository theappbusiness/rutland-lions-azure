resource "azurerm_synapse_sql_pool" "example_synapse" {
  count = var.synapse_sql_pool_enabled == true ? 1 : 0

  name                 = var.synapse_sql_pool_name
  synapse_workspace_id = azurerm_synapse_workspace.example_synapse.id
  sku_name             = var.synapse_sql_pool_sku
  create_mode          = "Default"
  collation            = "SQL_Latin1_General_CP1_CI_AS"

  tags = local.tags
}
