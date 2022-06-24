variable "environment" {
  default     = "dev"
  description = "The name of the environment into which resources will be deployed"
  type        = string
}

variable "location_pri" {
  description = "The Azure region abbreviation of the primary Virtual Network"
  type        = string
}

variable "location_sec" {
  description = "The Azure region abbreviation of the secondary Virtual Network"
  type        = string
}

variable "resource_group_name_pri" {
  description = "The name of the resource group containing the primary Virtual Network"
  type        = string
}

variable "resource_group_name_sec" {
  description = "The name of the resource group containing the secondary Virtual Network"
  type        = string
}

variable "vnet_id_pri" {
  description = "The ID of the primary Virtual Network"
  type        = string
}

variable "vnet_id_sec" {
  description = "The ID of the secondary Virtual Network"
  type        = string
}

variable "vnet_name_pri" {
  description = "The name of the primary Virtual Network"
  type        = string
}

variable "vnet_name_sec" {
  description = "The name of the secondary Virtual Network"
  type        = string
}
