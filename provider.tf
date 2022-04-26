terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
# AzureRM Provider
provider "azurerm" {
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    client_id = var.client_id
    client_secret = var.client_secret
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}
