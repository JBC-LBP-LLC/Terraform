
#
# Storage Account Module
#
locals {
  name = replace(var.name, "-", "")
}

resource "azurerm_storage_account" "storage" {
  name                              = local.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  enable_https_traffic_only         = var.enable_https_traffic_only

  tags = merge({
    Terraform = true
    },
    var.tags
  )
}

resource "azurerm_storage_share" "file_share" {
  name                 = var.file_share_names[count.index]
  quota                = length(var.file_share_quotas) > 0 ? var.file_share_quotas[count.index] : null
  storage_account_name = azurerm_storage_account.storage.name
  count                = length(var.file_share_names)
}

/*resource "azurerm_storage_account_network_rules" "test" {
  resource_group_name  = azurerm_resource_group.storage.resource_group_name
  storage_account_name = azurerm_storage_account.storage.name
  default_action             = "Allow"
  ip_rules                   = ["198.203.175.175", "198.203.181.181", "149.111.28.128", "149.111.30.128", "198.203.177.177"]
  //virtual_network_subnet_ids = [azurerm_subnet.test.id]
  //bypass                     = ["Metrics"]
}*/