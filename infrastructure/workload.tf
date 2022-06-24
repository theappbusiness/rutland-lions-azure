#========================================================================
# Example App Service IaC deployment
#========================================================================
# module "example_app_service" {
#   source = "./modules/example-app-service"

#   app_insights_retention_days = local.app_service_module_configuration[terraform.workspace].app_insights_retention_days
#   app_service_plan_sku        = local.app_service_module_configuration[terraform.workspace].app_service_plan_sku
#   app_service_type            = "Node.JS"
#   container_registry_sku      = local.app_service_module_configuration[terraform.workspace].container_registry_sku
#   environment                 = terraform.workspace

#   tags = {
#     CreatedBy = "Terraform"
#   }
# }

#========================================================================
# Example Kubernetes IaC deployment
#========================================================================
module "example_kubernetes" {
  source = "./modules/example-kubernetes"

  environment            = terraform.workspace
  kubernetes_node_count  = local.kubernetes_module_configuration[terraform.workspace].kubernetes_node_count
  kubernetes_node_vm_sku = local.kubernetes_module_configuration[terraform.workspace].kubernetes_node_vm_sku

  tags = {
    CreatedBy = "Terraform"
  }
}
