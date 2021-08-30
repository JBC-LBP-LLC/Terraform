
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Front Door service. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
}

variable "sku_name" {
  type        = string
  description = "(Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium."
  default     = "Basic"
}

variable "capacity" {
  type        = number
  description = "(Required) The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4."
  default     = "0"
}

variable "family" {
  type        = string
  description = "(Required) The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
  default     = "C"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet within which the Redis Cache should be deployed. This Subnet must only contain Azure Cache for Redis instances without any other type of resources."
  default     = ""
}

variable "redis_rdb_backup_enabled" {
  type        = bool
  description = "Is Backup Enabled?"
  default     = false
}

variable "redis_aof_backup_enabled" {
  type        = bool
  description = "Is Backup Enabled?"
  default     = false
}

variable "tags" {
  type        = map
  description = "A mapping of tags to assign to the resources."
  #default     = {}
}