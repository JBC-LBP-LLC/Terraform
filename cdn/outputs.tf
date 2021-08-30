
output "cdn_profile_id" {
  value = "${azurerm_cdn_profile.cdn_profile.id}"
}

# output "cdn_prfile_ids" {
#   value = "${azurerm_cdn_endpoint.cdn_endpoint.*.id}"
# }