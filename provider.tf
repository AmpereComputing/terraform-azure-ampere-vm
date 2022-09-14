terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
# AzureRM Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
# features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}
