#TODO Add a database for DB-Name and setup the user - as of now created manually
#Do we need to Ensure the AKS Subnet / VNET is allowed to ????
module mysql {
  source              = ".//modules/mysql"
  server_name         = "${local.resource_prefix}-mysql"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.auth

  administrator_login = var.secret_mysql_administrator_login
  administrator_login_password = var.secret_mysql_administrator_login_password

  storage_backup_retention_days = var.mysql_storage_backup_retention_days
  storage_in_mb       = var.mysql_storage_in_mb
  sku_name            = var.mysql_sku_name
  sku_capacity        = var.mysql_sku_capacity
  sku_tier            = var.mysql_sku_tier
  sku_family          = var.mysql_sku_family
  mysql_version       = "8.0"

  storage_auto_grow   = "true"

  databases           = [
    {
      name      = "spec_patient"
      charset   = "latin1"
      collation = "latin1_swedish_ci"
    }
  ]

  ssl_enforcement     = "true"
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics-mysql" {
  name               = "${local.resource_prefix}-mysql-diagnostics"
  target_resource_id = module.mysql.mysql_id
  //storage_account_id = module.storage-account.storage_account_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  log {
    category = "MySqlSlowLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "MySqlAuditLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}