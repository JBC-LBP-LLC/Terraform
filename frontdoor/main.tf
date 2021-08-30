
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_frontdoor" "frontdoor" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.main.name

  enforce_backend_pools_certificate_name_check = false

  dynamic "routing_rule" {
    for_each = local.forwarding_routing_rules
      content {
        name               = routing_rule.value.name
        accepted_protocols = routing_rule.value.accepted_protocols
        patterns_to_match  = routing_rule.value.patterns_to_match
        frontend_endpoints = routing_rule.value.frontend_endpoints
        forwarding_configuration {
          forwarding_protocol = routing_rule.value.forwarding_configuration.forwarding_protocol
          backend_pool_name   = routing_rule.value.forwarding_configuration.backend_pool_name
        }
      }
  }

  dynamic "routing_rule" {
    for_each = local.redirect_routing_rules
      content {
        name               = routing_rule.value.name
        accepted_protocols = routing_rule.value.accepted_protocols
        patterns_to_match  = routing_rule.value.patterns_to_match
        frontend_endpoints = routing_rule.value.frontend_endpoints
        redirect_configuration {
          redirect_protocol   = routing_rule.value.redirect_configuration.redirect_protocol
          redirect_type       = routing_rule.value.redirect_configuration.redirect_type
        }       
      }
  } 

  backend_pool_load_balancing {
    name = local.backend_pool_load_balancing.name
    sample_size = local.backend_pool_load_balancing.sample_size
    successful_samples_required = local.backend_pool_load_balancing.successful_samples_required
    additional_latency_milliseconds = local.backend_pool_load_balancing.additional_latency_milliseconds  
  }

  dynamic "backend_pool_health_probe" {
    for_each = var.backend_pool_health_probes
    content {
      name                = backend_pool_health_probe.value.name
      path                = backend_pool_health_probe.value.path
      protocol            = backend_pool_health_probe.value.protocol
      interval_in_seconds = backend_pool_health_probe.value.interval_in_seconds
    }
  }

  dynamic "backend_pool" {
    for_each = local.backend_pools
      content {
      name                        = backend_pool.value.name
      dynamic "backend" {
        for_each = backend_pool.value.backends
        content {
          host_header = backend.value.host_header
          address     = backend.value.address
          http_port   = backend.value.http_port
          https_port  = backend.value.https_port
          priority    = backend.value.priority
          weight      = backend.value.weight
          enabled     = backend.value.enabled
        }
      }

      load_balancing_name         = backend_pool.value.load_balancing_name
      health_probe_name           = backend_pool.value.health_probe_name
      }
  }

  dynamic "frontend_endpoint" {
    for_each = local.frontend_endpoints
      content {
      name                        = frontend_endpoint.value.name
      host_name                   = frontend_endpoint.value.host_name
      session_affinity_enabled    = frontend_endpoint.value.session_affinity_enabled
      session_affinity_ttl_seconds= frontend_endpoint.value.session_affinity_ttl_seconds
      custom_https_provisioning_enabled = frontend_endpoint.value.custom_https_provisioning_enabled

      #TODO - Rajeev - Refactor to find a better approach for this(to accommodate the optional https configuration)    
      dynamic "custom_https_configuration" {
        for_each = frontend_endpoint.value.custom_https_configuration
        content {
          certificate_source        = custom_https_configuration.value.https_cert_source
          azure_key_vault_certificate_vault_id = custom_https_configuration.value.https_cert_key_vault_id
          azure_key_vault_certificate_secret_name = custom_https_configuration.value.https_cert_secret_name
          azure_key_vault_certificate_secret_version = custom_https_configuration.value.https_cert_secret_version
        }
      }

      web_application_firewall_policy_link_id = frontend_endpoint.value.web_application_firewall_policy_link_id
      }
  }

  tags = merge({
    Terraform = true
    },
    var.tags
  ) 
}