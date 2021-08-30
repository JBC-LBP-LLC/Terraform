
output "redis_cache_id" {
  value = azurerm_redis_cache.redis_cache.id
}

output "redis_cache_primary_access_key" {
  value = azurerm_redis_cache.redis_cache.primary_access_key
}

output "redis_hostname" {
  value = azurerm_redis_cache.redis_cache.hostname
}