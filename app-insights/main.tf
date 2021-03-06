
resource "azurerm_application_insights" "this" {
  name                = var.name
  resource_group_name  = var.resource_group_name
  location            = var.location
  application_type    = "web"

  tags = merge({
    Terraform = true
    },
    var.tags
  )
}