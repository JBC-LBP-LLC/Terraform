#
# MySql for Azure PaaS
#
resource "azurerm_mysql_server" "mysql" {
  name                = var.server_name
  resource_group_name  = var.resource_group_name
  location            = var.location
  sku_name     = var.sku_name
  storage_mb            = var.storage_in_mb
  backup_retention_days = var.storage_backup_retention_days
  geo_redundant_backup_enabled  = var.storage_geo_redundant_backup
  auto_grow_enabled             = var.storage_auto_grow
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = var.mysql_version
  ssl_enforcement_enabled      = var.ssl_enforcement
  tags = var.tags
}
#
# MySql Server Parameters
#
resource "azurerm_mysql_configuration" "mysql" {
    count               = length(var.server_configuration_settings)
    name                = lookup(var.server_configuration_settings[count.index], "name")
    value               = lookup(var.server_configuration_settings[count.index], "value")
    server_name         = azurerm_mysql_server.mysql.name
    resource_group_name = azurerm_mysql_server.mysql.resource_group_name
}

#
# MySql Firewall Rules
#

resource "azurerm_mysql_firewall_rule" "mysql" {
    count               = length(var.firewall_rules)
    name                = lookup(var.firewall_rules[count.index], "name")
    resource_group_name = azurerm_mysql_server.mysql.resource_group_name
    server_name         = azurerm_mysql_server.mysql.name
    start_ip_address    = lookup(var.firewall_rules[count.index], "start_ip_address")
    end_ip_address      = lookup(var.firewall_rules[count.index], "start_ip_address")
}

#
# MySql Databases
#

resource "azurerm_mysql_database" "mysql" {
    count               = length(var.databases)
    name                = lookup(var.databases[count.index], "name")
    resource_group_name = azurerm_mysql_server.mysql.resource_group_name
    server_name         = azurerm_mysql_server.mysql.name
    charset             = lookup(var.databases[count.index], "charset")
    collation           = lookup(var.databases[count.index], "collation")
}

#
# Network Rules
#

resource "azurerm_mysql_virtual_network_rule" "rules" {
    count               = length(var.network_rules)
    name                = lookup(var.network_rules[count.index], "name")
    resource_group_name = azurerm_mysql_server.mysql.resource_group_name
    server_name         = azurerm_mysql_server.mysql.name
    subnet_id           = lookup(var.network_rules[count.index], "subnet_id")
}