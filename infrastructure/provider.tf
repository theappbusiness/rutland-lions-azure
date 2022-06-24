terraform {
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    resource_group_name  = "rg-terraform-prod-uks"
    subscription_id      = "de592fa3-d646-4e2d-b745-69da97e8af27"
    storage_account_name = "tfstateproduks32jn2n"
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

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
