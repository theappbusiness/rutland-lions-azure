resource "azurerm_kubernetes_cluster" "example_kubernetes" {
  #checkov:skip=CKV_AZURE_4: Skip AKS Azure Monitor logging for demo
  #checkov:skip=CKV_AZURE_5: Skip AKS RBAC for demo
  #checkov:skip=CKV_AZURE_6: Skip authorized IP ranges for demo
  #checkov:skip=CKV_AZURE_7: Skip AKS network policy for demo
  #checkov:skip=CKV_AZURE_115: Skip private AKS cluster for demo
  #checkov:skip=CKV_AZURE_116: Skip AKS Azure Policy add-on for demo
  #checkov:skip=CKV_AZURE_117: Skip AKS disk encryption for demo
  #checkov:skip=CKV_AZURE_141: Skip AKS local admin disabled for demo
  name                = "aks-ex-aks-${var.environment}"
  resource_group_name = azurerm_resource_group.example_kubernetes.name
  location            = azurerm_resource_group.example_kubernetes.location
  dns_prefix          = "exk8s${var.environment}"
  node_resource_group = "rg-ex-aks-nodes-${var.environment}"

  default_node_pool {
    name       = "default"
    vm_size    = var.kubernetes_node_vm_sku
    node_count = var.kubernetes_node_count
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}
