terraform {
  backend "azurerm" {
    container_name       = "<storageAccountContainerName>"
    key                  = "terraform.tfstate"
    resource_group_name  = "<storageAccountResourceGroupName>"
    subscription_id      = "<storageAccountSubscriptionId>"
    storage_account_name = "<sotrageAccountName>"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = "1.1.6"
}

provider "azurerm" {
  client_id       = var.tf_provider_client_id
  client_secret   = var.tf_provider_client_secret
  subscription_id = var.tf_provider_subscription_id
  tenant_id       = var.tf_provider_tenant_id

  features {}
}
