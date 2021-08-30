
variable "name" {
    description = "The name of the Web application firewall policy create."
    type = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which the WAF Policy to be created."
    type = string
}

variable "waf_mode" {
    description = "The WAF Policy mode. Defaulting to Detection based on the experience and feedback on Specialty. Azure Default is also Detection"
    type = string
    default = "Detection"
}

variable "enabled" {
    description = "Flag whether the WAF Policy is enabled or not."
    type = bool
    default = true
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}