
variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}

variable "enable_https_traffic_only" {
  type    = bool
  default = true
}

variable "enable_advanced_threat_protection" {
  type    = bool
  default = false
}

variable "file_share_names" {
  description = "The Azure File Shares to create"
  default     = []
}

variable "file_share_quotas" {
  description = "The quota in GB for the file shares."
  default     = null
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}

## POC to add firewall to storage accoun t and IP whitelisting
/*variable "default_action" {
  description = "(Required) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow"
  default = "Deny"
}

variable "virtual_network_subnet_ids" {
  description = "(Required) A list of resource ids for subnets."
  type = "list"
}

variable "optum_ip_addresses" {
  description = "(Required) A list of optum_ip_addresses"
  type = "list"
}*/