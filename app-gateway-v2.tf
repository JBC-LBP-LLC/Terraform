#
# Application Gateway with WAf V2
#

locals {
  # Naming prefix for app gateway components
  vnet_name                      = module.main_vnet.vnet_name
  backend_address_pool_name      = "backend-pool"
  frontend_port_name_http        = "${local.vnet_name}-feport-http"
  frontend_port_name_https       = "${local.vnet_name}-feport-https"
  frontend_ip_configuration_name = "AGW-public-ip-frontend"
  http_setting_name              = "http"
  listener_name                  = "listener-http"
  request_routing_rule_name      = "rule-http"
  redirect_configuration_name    = "${local.vnet_name}-rdrcfg"
}

resource "azurerm_application_gateway" "agw" {
  name                = "${local.resource_prefix}-agw"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  enable_http2        = true

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = module.main_vnet.vnet_subnets[2]
  }

  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }

  frontend_port {
    name = local.frontend_port_name_https
    port = 443
  }
 
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }
 
  backend_address_pool {
    name  = local.backend_address_pool_name
    ip_addresses = ["${var.apim_backend_address_pool_ip_addresses}"]
  }
 
  backend_http_settings {
    name                                = "${local.http_setting_name}s"
    cookie_based_affinity               = "Disabled"
    path                                = ""
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 60
    //pick_host_name_from_backend_address = true
    //affinity_cookie_name                = "ApplicationGatewayAffinity"
    host_name                           = var.host_name_http_settings
    probe_name                          = "HealthCheck"
    connection_draining {
      enabled = true
      drain_timeout_sec = 60
    }
  }
 
  probe {
    pick_host_name_from_backend_http_settings = true
    interval                                  = 30
    name                                      = "HealthCheck"
    protocol                                  = "HTTPS"
    path                                      = "/health/check"
    timeout                                   = 30
    unhealthy_threshold                       = 3

    match {
      status_code = ["200-399"]
      body        = ""
    }
  }
 
  /*probe {
    pick_host_name_from_backend_http_settings = true
    interval                                  = 30
    name                                      = "HTTP"
    protocol                                  = "HTTP"
    path                                      = "/"
    timeout                                   = 30
    unhealthy_threshold                       = 3

    match {
      status_code = ["200-399"]
      body        = ""
    }
  }*/

  http_listener {
    name                           = "${local.listener_name}s"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_https
    protocol                       = "Https"
    host_name                      = var.apim_host_name
   require_sni                    = true
    ssl_certificate_name           = "sslcert"
  }
 
  request_routing_rule {
    name                       = "${local.request_routing_rule_name}s"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}s"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = "${local.http_setting_name}s"
  }
 
  waf_configuration {
    enabled                  = true
    firewall_mode            = "Prevention"
    rule_set_type            = "OWASP"
    rule_set_version         = "3.0"
    request_body_check       = true
    max_request_body_size_kb = "128"
    file_upload_limit_mb     = "100"
  }
 
    ssl_policy {
      //policy_type          = "Default"
       policy_type          = "Custom"
       min_protocol_version = "TLSv1_2"
       cipher_suites = [
         "TLS_RSA_WITH_AES_256_CBC_SHA256",
         "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384",
         "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
         "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
         "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
         "TLS_RSA_WITH_AES_128_GCM_SHA256",
         "TLS_RSA_WITH_AES_128_CBC_SHA256"
       ]
   }
 
  #TODO: Get real cert
  ssl_certificate {
    name     = "sslcert"
    data     = filebase64(var.certificate-path)
    password = var.secret_cert_password
  }

  tags       = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnos-agw-log" {
  name               = "${azurerm_application_gateway.agw.name}-diagnostics"
  target_resource_id = azurerm_application_gateway.agw.id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  } 

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  } 

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}