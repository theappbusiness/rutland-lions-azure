output "kubernetes_client_certificate" {
  description = "Base64 encoded public certificate used to authenticate to the Kubernetes cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.example_kubernetes.kube_config.0.client_certificate
}

output "kubernetes_kube_config" {
  description = "Raw Kubernetes configuration used by kubectl and other tools"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.example_kubernetes.kube_config_raw
}
