
variable "prefix" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "domain_name_label" {
    type = string
    default = null
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}