locals {
  #========================================================================
  # Example App Service IaC deployment
  #========================================================================
  # app_service_module_configuration = {
  #   dev = {
  #     app_service_plan_sku        = "B1"
  #     app_insights_retention_days = 30
  #     container_registry_sku      = "Basic"
  #     key_vault_sku               = "standard"
  #   }
  #   test = {
  #     app_service_plan_sku        = "S1"
  #     app_insights_retention_days = 60
  #     container_registry_sku      = "Standard"
  #     key_vault_sku               = "standard"
  #   }
  #   prod = {
  #     app_service_plan_sku        = "P1v2"
  #     app_insights_retention_days = 365
  #     container_registry_sku      = "Premium"
  #     key_vault_sku               = "premium"
  #   }
  # }

  #========================================================================
  # Example Kubernetes IaC deployment
  #========================================================================
  kubernetes_module_configuration = {
    dev = {
      kubernetes_node_count  = 1
      kubernetes_node_vm_sku = "Standard_D2_v2"
    }
    test = {
      kubernetes_node_count  = 3
      kubernetes_node_vm_sku = "Standard_D2_v2"
    }
    prod = {
      kubernetes_node_count  = 3
      kubernetes_node_vm_sku = "Standard_D3_v2"
    }
  }
}
