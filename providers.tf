#
# Terraform Provider
#

terraform {
  required_version = ">= 0.12.8, < 0.13.36"
  backend "azurerm" {
    storage_account_name = "__terraformstorageaccount__"
    container_name       = "__container_name__"
    key                  = "__tfstatefile__"
    access_key           = "__storagekey__"
  }
}

#
# Random string generator Provider
#
provider "random" {
  version = "2.2.0"
}

#
# Azure Provider
#
provider "azurerm" {
  version         = "2.38.0"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  skip_provider_registration = true
  features {}
}