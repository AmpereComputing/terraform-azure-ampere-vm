terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
# AzureRM Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}
