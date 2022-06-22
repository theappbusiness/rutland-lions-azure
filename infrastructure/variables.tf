variable "tf_provider_client_id" {
  default     = null # Sourced from ARM_CLIENT_ID by default
  description = "The service principal client ID used by Terraform to connect to Azure"
  sensitive   = true
  type        = string
}

variable "tf_provider_client_secret" {
  default     = null # Sourced from ARM_CLIENT_SECRET by default
  description = "The service principal client secret used by Terraform to connect to Azure"
  sensitive   = true
  type        = string
}

variable "tf_provider_subscription_id" {
  default     = null # Sourced from ARM_SUBSCRIPTION_ID by default
  description = "The Azure subscription ID where resources will be provisioned by Terraform"
  type        = string
}

variable "tf_provider_tenant_id" {
  default     = null # Sourced from ARM_TENANT_ID by default
  description = "The Azure tenant ID containing the service principal used by Terraform"
  type        = string
}
