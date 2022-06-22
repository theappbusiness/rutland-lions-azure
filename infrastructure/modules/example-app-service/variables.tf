variable "app_insights_retention_days" {
  default     = 30
  description = "The number of days to retain Application Insight logs"
  type        = number
}

variable "app_service_principal_id" {
  default     = null
  description = "The Azure AD built-in App Service principal ID for the Azure AD tenant"
  type        = string
}

variable "app_service_plan_sku" {
  default     = "B1"
  description = "The App Service Plan SKU"
  type        = string
}

variable "app_service_type" {
  default     = "other"
  description = "The type of App Service being deployed and monitored by Application Insights"
  type        = string
}

variable "app_settings" {
  default     = {}
  description = "A map of settings to be passed into the App Service as environment variables"
  type        = map(string)
}

variable "container_image_name" {
  default     = null
  description = "The Docker iamge name to reference in Azure Container Registry"
  type        = string
}

variable "container_image_tag" {
  default     = "main"
  description = "The Docker image tag to reference in Azure Container Registry"
  type        = string
}

variable "container_registry_sku" {
  default     = "Basic"
  description = "The Azure Container Regsitry SKU"
  type        = string
}

variable "custom_hostname" {
  default     = null
  description = "The custom hostname to be assigned to the App Service"
  type        = string
}

variable "custom_hostname_certificate_secret_id" {
  default     = null
  description = "The Key Vault URL for the custom hostname certificate"
  type        = string
}

variable "environment" {
  default     = "dev"
  description = "The environment name in which to deploy resources"
  type        = string
}

variable "key_vault_sku" {
  default     = "standard"
  description = "The Key Vault SKU"
  type        = string
}

variable "location" {
  default     = "uksouth"
  description = "The Azure region in which to deploy resources"
  type        = string
}

variable "location_secondary" {
  default     = "ukwest"
  description = "The Azure region in which to deploy secondary or failover resources"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
}
