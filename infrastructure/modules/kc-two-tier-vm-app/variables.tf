variable "computer_name_prefix_web" {
  default     = "web"
  description = "The prefix to be used as the Windows computer name for web compute instances"
  type        = string
}

variable "computer_name_prefix_data" {
  default     = "sql"
  description = "The prefix to be used as the Windows computer name for data compute instances"
  type        = string
}

variable "environment" {
  default     = "dev"
  description = "The name of the environment into which resources will be deployed"
  type        = string
}

variable "location" {
  default     = "uks"
  description = "The Azure region abbreviation into which to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group into which to deploy resources"
  type        = string
}

variable "resource_suffix" {
  description = "A suffix to apply to resource names for consistency"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
}

variable "vnet_subnets" {
  description = "A list of subnets to reference for compute placement"
  type        = map(string)
}

variable "vm_admin_username" {
  default     = "kcadmin"
  description = "The username for the local administrator account on each compute instance"
  type        = string
}

variable "vm_size_data" {
  default     = "Standard_E2_v4"
  description = "The size of each data compute instance"
  type        = string
}

variable "vm_size_web" {
  default     = "Standard_D2_v4"
  description = "The size of each web compute instance"
  type        = string
}
