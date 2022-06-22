resource "azurerm_synapse_spark_pool" "example_synapse" {
  count = var.synapse_spark_pool_enabled == true ? 1 : 0

  name                 = var.synapse_spark_pool_name
  synapse_workspace_id = azurerm_synapse_workspace.example_synapse.id
  node_size_family     = var.synapse_spark_pool_node_family
  node_size            = var.synapse_spark_pool_node_size
  node_count           = var.synapse_spark_pool_autoscaling_enabled == false ? var.synapse_spark_pool_node_count : null

  auto_pause {
    delay_in_minutes = 15
  }

  dynamic "auto_scale" {
    for_each = var.synapse_spark_pool_autoscaling_enabled ? [1] : []

    content {
      max_node_count = var.synapse_spark_pool_autoscaling_max_node_count
      min_node_count = var.synapse_spark_pool_autoscaling_min_node_count
    }
  }

  tags = local.tags
}
