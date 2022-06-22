resource "azurerm_role_assignment" "synapse_data_lake_contributor" {
  scope                = azurerm_storage_account.example_synapse.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.example_synapse.identity[0].principal_id
}
