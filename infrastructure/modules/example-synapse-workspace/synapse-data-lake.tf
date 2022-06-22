resource "azurerm_storage_account" "example_synapse" {
  #checkov:skip=CKV_AZURE_33:   TODO: Queue logging configuration
  #checkov:skip=CKV_AZURE_35:   TODO: Network access rules
  #checkov:skip=CKV_AZURE_43:   SKIP: Name format is correct
  #checkov:skip=CKV2_AZURE_1:   TODO: Customer-managed keys
  #checkov:skip=CKV2_AZURE_8:   TODO: Activity log monitoring
  #checkov:skip=CKV2_AZURE_18:  TODO: Customer-managed keys
  name                      = replace("st-ex-syn-${var.environment}", "-", "")
  resource_group_name       = azurerm_resource_group.example_synapse.name
  location                  = azurerm_resource_group.example_synapse.location
  account_tier              = var.data_lake_account_tier
  account_replication_type  = var.data_lake_account_replication_type
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  is_hns_enabled            = true
  min_tls_version           = "TLS1_2"

  tags = local.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example_synapse" {
  name               = replace("dlfs-ex-syn-${var.environment}", "-", "")
  storage_account_id = azurerm_storage_account.example_synapse.id
}
