
variable "profile_name" {
  type        = string
  description = "(Required) Specifies the name of the Front Door service. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created."
}

variable "sku" {
  type        = string
  description = "(Required) The pricing related information of current CDN profile. Accepted values are Standard_Akamai, Standard_ChinaCdn, Standard_Microsoft, Standard_Verizon or Premium_Verizon."
  default     = "Standard_Microsoft"
}

variable "tags" {
  type        = map
  description = "A mapping of tags to assign to the resources."
  #default     = {}
}

variable "endpoints" {
  type        = list(any)
  default     = [{}]
}

variable "is_http_allowed" {
  type        = bool
  default     = false
}

variable "is_compression_enabled" {
  type        = bool
  default     = false
}

locals {
  endpoints   = [
  for p in var.endpoints : merge ({
  },p)
  ]
}