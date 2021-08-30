
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_frontdoor_firewall_policy" "fd_waf_policy" {
  name                            = var.name
  resource_group_name             = data.azurerm_resource_group.main.name
  enabled = var.enabled
  mode    = var.waf_mode

  tags = merge({
    Terraform = true
    },
    var.tags
  )
}