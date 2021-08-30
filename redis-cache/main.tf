
resource "azurerm_redis_cache" "redis_cache" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku_name                        = var.sku_name
  capacity                        = var.capacity
  family                          = var.family
  minimum_tls_version             = "1.2"
  enable_non_ssl_port             = false
  subnet_id                       = var.subnet_id

  #TODO - For future add the support for redis_configuration block
   redis_configuration {
      rdb_backup_enabled          = var.redis_rdb_backup_enabled
      aof_backup_enabled          = var.redis_aof_backup_enabled
  }

  tags = merge({
    Terraform = true
    },
    var.tags
  ) 
}