
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Front Door service. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "Location of Front Door. Defaults to Global - but for backward compatibility, providing the option "
  default     = "Global"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map
  description = "A mapping of tags to assign to the resources."
  default     = {}
}

variable "frontend_endpoints" {
  type        = list(any)
  default     = [{}]
}

variable "backend_pools" {
  type        = list(any)
  default     = [{}]
}

variable "forwarding_routing_rules" {
  type        = list(any)
  default     = [{}]
}

variable "redirect_routing_rules" {
  type        = list(any)
  default     = [{}]
}

variable backend_pool_load_balancing {
  type       = any
  default    = {}
}

variable backend_pool_health_probes {
  type       = list(any)
}

variable "custom_https_provisioning_enabled" {
  type      = bool
  default   = false
}

locals {
  frontend_endpoints   = [
  for p in var.frontend_endpoints : merge ({
      name                        = "frontend-name"
      host_name                   = "www.optum.com"
      session_affinity_enabled    = false
      session_affinity_ttl_seconds= 0
      custom_https_provisioning_enabled = false
      web_application_firewall_policy_link_id = null
      custom_https_configuration = []
  },p)
  ]

  backend_pools   = [
  for p in var.backend_pools : merge ({
      name                        = "backendpool-name"
      backends    = [
      for m in p.backends   : merge({
            enabled       = true
        },m)
      ]

      load_balancing_name         = local.backend_pool_load_balancing.name
      health_probe_name           = null
  },p)
  ]

  forwarding_routing_rules = [
    for p in var.forwarding_routing_rules : merge({
      name               = "Example-Rule1"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/*"]
      frontend_endpoints = []
      forwarding_configuration = {
        forwarding_protocol = "MatchRequest"
        backend_pool_name   = ""
        cache_enabled       = "false"
      }
    },p)
  ]

  redirect_routing_rules = [
    for p in var.redirect_routing_rules : merge({
      name               = "Example-Rule1"
      accepted_protocols = ["Http"]
      patterns_to_match  = ["/*"]
      frontend_endpoints = []
      redirect_configuration = {
        redirect_type       = "Found"
        redirect_protocol   = "HttpsOnly"
      }
    },p)
  ]     

  backend_pool_load_balancing = merge({
    name     = "load_balancing_name"
    sample_size = 4
    successful_samples_required = 2
    additional_latency_milliseconds = 0
  },var.backend_pool_load_balancing)

  # backend_pool_health_probes =  [
  #   for p in var.backend_pool_health_probes : merge({
  #   name     = "health-check"
  #   path = "/"
  #   protocol = "Https"
  #   interval_in_seconds = "120"
  # },p)
  # ]
}