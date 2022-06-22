variable "data_lake_account_replication_type" {
  default     = "LRS"
  description = "The replication mode of the Date Lake Gen2 Storage Account"
  type        = string
}

variable "data_lake_account_tier" {
  default     = "Standard"
  description = "The SKU of the Data Lake Gen2 Storage Account"
  type        = string
}

variable "environment" {
  default     = "dev"
  description = "The environment name in which to deploy resources"
  type        = string
}

variable "location" {
  default     = "uksouth"
  description = "The Azure region in which to deploy resources"
  type        = string
}

variable "synapse_github_repo_account_name" {
  default     = null
  description = "The name of the GitHub account hosting the GitHub repository associated with the Synapse Workspace"
  type        = string
}

variable "synapse_github_repo_branch_name" {
  default     = "main"
  description = "The name of the branch to retrieve code from for the associated with the Synapse Workspace"
  type        = string
}

variable "synapse_github_repo_enabled" {
  default     = false
  description = "A flag to indicate if a GitHub repository should be linked to the Synapse Workspace"
  type        = bool
}

variable "synapse_github_repo_name" {
  default     = null
  description = "The name of the GitHub repository associated with the Synapse Workspace"
  type        = string
}

variable "synapse_github_repo_root_folder" {
  default     = "/"
  description = "The root folder within the GitHub repository associated with the Synapse Workspace"
  type        = string
}

variable "synapse_spark_pool_autoscaling_enabled" {
  default     = false
  description = "A flag to indicate if autoscaling should be enabled for the Spark Pool linked to the Synapse Workspace"
  type        = bool
}

variable "synapse_spark_pool_autoscaling_max_node_count" {
  default     = 12
  description = "The maximum number of nodes that can be scaled up to for the Spark Pool linked to the Synapse Workspace"
  type        = number
}

variable "synapse_spark_pool_autoscaling_min_node_count" {
  default     = 3
  description = "The minimum number of nodes that can be scaled down to for the Spark Pool linked to the Synapse Workspace"
  type        = number
}

variable "synapse_spark_pool_enabled" {
  default     = false
  description = "A flag to indicate if a Spark Pool should be provisioned and linked to the Synapse Workspace"
  type        = bool
}

variable "synapse_spark_pool_name" {
  default     = "synsp01"
  description = "The name for the Spark Pool linked with the Synapse Workspace"
  type        = string
}

variable "synapse_spark_pool_node_count" {
  default     = 3
  description = "The number of nodes to provision as part of the Spark Pool linked with the Synapse Workspace"
  type        = number
}

variable "synapse_spark_pool_node_family" {
  default     = "MemoryOptimized"
  description = "The type of nodes to provision as part of the Spark Pool linked with the Synapse Workspace"
  type        = string
}

variable "synapse_spark_pool_node_size" {
  default     = "Small"
  description = "The size of nodes to provision as part of the Spark Pool linked with the Synapse Workspace"
  type        = string
}

variable "synapse_sql_aad_administrator_enabled" {
  default     = false
  description = "A flag to indicate if an Azure AD account should be used for SQL administration in the Synapse Workspace"
  type        = bool
}

variable "synapse_sql_aad_administrator_object_id" {
  default     = null
  description = "The object ID of the Azure AD account used for SQL administration in the Synapse Workspace"
  type        = string
}

variable "synapse_sql_aad_administrator_username" {
  default     = null
  description = "The username of the Azure AD account used for SQL administration in the Synapse Workspace"
  type        = string
}

variable "synapse_sql_administrator_username" {
  default     = "synapseadmin"
  description = "The SQL administrator username for the Synapse Workspace"
  type        = string
}

variable "synapse_sql_pool_enabled" {
  default     = false
  description = "A flag to indicate if a Dedicated SQL Pool should be provisioned and linked to the Synapse Workspace"
  type        = bool
}

variable "synapse_sql_pool_name" {
  default     = "syndp01"
  description = "The name for the Dedicated SQL Pool linked with the Synapse Workspace"
  type        = string
}

variable "synapse_sql_pool_sku" {
  default     = "DW100c"
  description = "The SKU of the Dedicated SQL Pool linked with the Synapse Workspace"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A collection of tags to assign to taggable resources"
  type        = map(string)
}
