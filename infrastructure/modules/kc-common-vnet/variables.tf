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

variable "vnet_base_cidr_block" {
  default     = "10.90.0.0/24"
  description = "The base IPv4 range for the Virtual Network in CIDR notation"
  type        = string
}

variable "vnet_subnets" {
  default = [
    {
      name     = "T1Subnet"
      new_bits = 1
    },
    {
      name     = "T2Subnet"
      new_bits = 2
    }
  ]
  description = "A collection of subnet definitions used to logically partition the Virtual Network"
  type        = list(map(string))
}
