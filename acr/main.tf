#
# Azure Container Registry
#

locals {
  #name  = "${var.prefix}-acr"
  name = replace(var.name, "-", "")
}

/*data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}*/

resource "azurerm_container_registry" "acr" {
  # NOTE: In ACR name you cannot use hyphens.
  name                = local.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_user_enabled

  tags = merge({
    Terraform = true
    },
    var.tags
  )
}