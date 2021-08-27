## Redis Cache for Auth-patient
module redis_cache {
  source              = ".//modules/redis-cache"
  name                = "${local.resource_prefix}-auth-rc"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.auth
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name

  ## Allowing connections fron ASK using AKS subnet
  //subnet_id           = module.main_vnet.vnet_subnets[0]
  redis_rdb_backup_enabled = false
  redis_aof_backup_enabled = false
}

## Redis Cache diagnostics
resource "azurerm_monitor_diagnostic_setting" "redis-auth-diagnos" {
  name               = "${local.resource_prefix}-redis-ds"
  target_resource_id = module.redis_cache.redis_cache_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}

## Redis Cache for UnAuth-patient
module redis_cache_UnAuth {
  source              = ".//modules/redis-cache"
  name                = "${local.resource_prefix}-redis-unAuth"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.auth
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name

  ## Allowing connections fron ASK using AKS subnet
  //subnet_id           = module.main_vnet.vnet_subnets[0]

  redis_rdb_backup_enabled = false
  redis_aof_backup_enabled = false
}

## Redis Cache diagnostics
resource "azurerm_monitor_diagnostic_setting" "redis-Unauth-diagnos" {
  name               = "${local.resource_prefix}-redis-ds"
  target_resource_id = module.redis_cache_UnAuth.redis_cache_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}