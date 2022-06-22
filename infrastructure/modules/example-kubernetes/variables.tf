variable "environment" {
  default     = "dev"
  description = "The environment name in which to deploy resources"
  type        = string
}

variable "kubernetes_node_vm_sku" {
  default     = "Standard_D2_v2"
  description = "The VM SKU for each node in the Kubernetes cluster"
  type        = string
}

variable "kubernetes_node_count" {
  default     = 1
  description = "The number of nodes in the Kubernetes cluster"
  type        = number
}

variable "location" {
  default     = "uksouth"
  description = "The Azure region in which to deploy resources"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
}
