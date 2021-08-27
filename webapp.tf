#

# App Service Plan (Linux)

#

resource "azurerm_app_service_plan" "main" {

  name                = "${local.resource_prefix}-asp"

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

  kind                = "Linux"

 

  sku {

    tier     = "PremiumV2"

    size     = "P3v2"

    capacity = 2

  }

 

  reserved = true

 

  tags = local.auth

}

 

#

# Autoscaling for Web App (Linux)

#

resource "azurerm_monitor_autoscale_setting" "main" {

  name                = "${azurerm_app_service_plan.main.name}-autoscale"

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

  target_resource_id  = azurerm_app_service_plan.main.id

  depends_on = [azurerm_app_service_plan.main, azurerm_app_service.main]

  profile {

    name = "defaultProfile"

 

    capacity {

      default = 2

      minimum = 2

      maximum = 10

    }

 

    rule {

      metric_trigger {

        metric_name        = "CPUPercentage"

        metric_resource_id = azurerm_app_service_plan.main.id

        time_grain         = "PT1M"

        statistic          = "Average"

        time_window        = "PT10M"

        time_aggregation   = "Average"

        operator           = "GreaterThan"

        threshold          = 70

      }

 

      scale_action {

        direction = "Increase"

        type      = "ChangeCount"

        value     = "2"

        cooldown  = "PT5M"

      }

    }

 

    rule {

      metric_trigger {

        metric_name        = "CPUPercentage"

        metric_resource_id = azurerm_app_service_plan.main.id

        time_grain         = "PT1M"

        statistic          = "Average"

        time_window        = "PT10M"

        time_aggregation   = "Average"

        operator           = "LessThan"

        threshold          = 50

      }

 

      scale_action {

        direction = "Decrease"

        type      = "ChangeCount"

        value     = "1"

        cooldown  = "PT5M"

      }

    }

  }

}

 

#

# Web App (Linux)

#

resource "azurerm_app_service" "main" {

  name                    = "${local.resource_prefix}-app"

  location                = var.location

  app_service_plan_id     = azurerm_app_service_plan.main.id

  resource_group_name     = module.main_resource_group.resource_group_name

  client_affinity_enabled = false

  client_cert_enabled     = false

  https_only              = true

 

  app_settings = {

    "APP_ENV"                             = var.APP_ENV  

    "APPINSIGHTS_INSTRUMENTATIONKEY"      = module.app_insights_UI.instrumentation_key

    "AZURE_TENANT_ID"                     = var.AZURE_TENANT_ID

    "AZURE_VAULT_CLIENT_ID"               = var.AZURE_VAULT_CLIENT_ID

    "AZURE_VAULT_CLIENT_SECRET"           = var.AZURE_VAULT_CLIENT_SECRET

    "AZURE_VAULT_NAME"                    = var.AZURE_VAULT_NAME

    "BASE_PATH"                           = "/patients"

    "DOCKER_ENABLE_CI"                    = "true"

    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.DOCKER_REGISTRY_SERVER_PASSWORD

    "DOCKER_REGISTRY_SERVER_URL"          = var.DOCKER_REGISTRY_SERVER_URL

    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.DOCKER_REGISTRY_SERVER_USERNAME

    "HSID_LOGOUT_URL"                     = var.HSID_LOGOUT_URL

    "LOGIN_URL"                           = var.LOGIN_URL

    "SESSION_TIMEOUT"                     = var.SESSION_TIMEOUT

    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

    "WEBSITES_PORT"                       = var.WEBSITES_PORT

   

  }

 

  site_config {

    always_on                 = true

    ftps_state                = "AllAllowed"

    http2_enabled             = false

    linux_fx_version          = var.webapp_config_linux_fx_version

    min_tls_version           = "1.2"

    use_32_bit_worker_process = true

    default_documents = [

      "Default.htm",

      "Default.html",

      "Default.asp",

      "index.htm",

      "index.html",

      "iisstart.htm",

      "default.aspx",

      "index.php",

      "hostingstart.html"

    ]

 

    cors {

      allowed_origins     = [""]

      support_credentials = false

    }

  }

 

  logs {

    http_logs {

      file_system {

        retention_in_days = 10

        retention_in_mb   = 35

      }

    }

  }

 

  identity {

    type = "SystemAssigned"

  }

  tags = local.auth

 

}

 

## WebApp Diagnostic Settings

 

resource "azurerm_monitor_diagnostic_setting" "main-diagnos" {

  name               = "${azurerm_app_service.main.name}-ds"

  target_resource_id = azurerm_app_service.main.id

  log_analytics_workspace_id = module.log_analytics_workspace.id

 

  log {

    category = "AppServiceHTTPLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

log {

    category = "AppServiceConsoleLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

log {

    category = "AppServiceAppLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

  log {

    category = "AppServiceFileAuditLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

  log {

    category = "AppServiceAuditLogs"

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

 

## webapp UI slot-B

 

resource "azurerm_app_service_slot" "slot" {

  name                    = "${local.resource_prefix}-app"

  app_service_name        = azurerm_app_service.main.name

  location                = var.location

  app_service_plan_id     = azurerm_app_service_plan.main.id

  resource_group_name     = module.main_resource_group.resource_group_name

  client_affinity_enabled = false

  //client_cert_enabled     = false

  https_only              = true

 

  app_settings = {

    "APP_ENV"                             = var.APP_ENV  

    "APPINSIGHTS_INSTRUMENTATIONKEY"      = module.app_insights_UI.instrumentation_key

    "AZURE_TENANT_ID"                     = var.AZURE_TENANT_ID

    "AZURE_VAULT_CLIENT_ID"               = var.AZURE_VAULT_CLIENT_ID

    "AZURE_VAULT_CLIENT_SECRET"           = var.AZURE_VAULT_CLIENT_SECRET

    "AZURE_VAULT_NAME"                    = var.AZURE_VAULT_NAME

    "BASE_PATH"                           = "/patients"

    "DOCKER_ENABLE_CI"                    = "true"

    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.DOCKER_REGISTRY_SERVER_PASSWORD

    "DOCKER_REGISTRY_SERVER_URL"          = var.DOCKER_REGISTRY_SERVER_URL

    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.DOCKER_REGISTRY_SERVER_USERNAME

    "HSID_LOGOUT_URL"                     = var.HSID_LOGOUT_URL

    "LOGIN_URL"                           = var.LOGIN_URL

    "SESSION_TIMEOUT"                     = var.SESSION_TIMEOUT

    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

    "WEBSITES_PORT"                       = var.WEBSITES_PORT

   

  }

 

  site_config {

    always_on                 = true

    ftps_state                = "AllAllowed"

    http2_enabled             = false

    linux_fx_version          = "${var.webapp_config_linux_fx_version}"

    min_tls_version           = "1.2"

    use_32_bit_worker_process = true

    default_documents = [

      "Default.htm",

      "Default.html",

      "Default.asp",

      "index.htm",

      "index.html",

      "iisstart.htm",

      "default.aspx",

      "index.php",

      "hostingstart.html"

    ]

 

    cors {

      allowed_origins     = [""]

      support_credentials = false

    }

  }

 

  logs {

    http_logs {

      file_system {

        retention_in_days = 10

        retention_in_mb   = 35

      }

    }

  }

 

  identity {

    type = "SystemAssigned"

  }

  tags = local.auth

 

}

 

 

 

#

# Web App (Linux) for Auth-proxy

#

resource "azurerm_app_service" "Auth-proxy" {

  name                    = "${local.resource_prefix}-Auth-proxy-app"

  location                = var.location

  app_service_plan_id     = azurerm_app_service_plan.main.id

  resource_group_name     = module.main_resource_group.resource_group_name

  client_affinity_enabled = false

  client_cert_enabled     = false

  https_only              = true

 

  app_settings = {

 

      "APIM_BASE_TOKEN_URL"                = var.APIM_BASE_TOKEN_URL

      "APIM_SUBJECT_HEADER_NAME"           = var.APIM_SUBJECT_HEADER_NAME

      "APIM_TARGET_PROXY_URL"              = var.APIM_TARGET_PROXY_URL

      "APPINSIGHTS_INSTRUMENTATIONKEY"     = module.app_insights_proxy.instrumentation_key

      "CORS_ALLOWED_HEADERS"               = var.CORS_ALLOWED_HEADERS

      "CORS_ALLOWED_ORIGINS"               = var.CORS_ALLOWED_ORIGINS

      "DATA_PROVIDER_NAMES"                = var.DATA_PROVIDER_NAMES

      "DOCKER_ENABLE_CI"                   = "true"

      "DOCKER_REGISTRY_SERVER_PASSWORD"    = var.DOCKER_REGISTRY_SERVER_PASSWORD

      "DOCKER_REGISTRY_SERVER_URL"         = var.DOCKER_REGISTRY_SERVER_URL

      "DOCKER_REGISTRY_SERVER_USERNAME"    = var.DOCKER_REGISTRY_SERVER_USERNAME

      "HEMI_BASE_TOKEN_URL"                = var.HEMI_BASE_TOKEN_URL

      "HEMI_TARGET_PROXY_URL"              = var.HEMI_TARGET_PROXY_URL

      "INCLUDE_ACCESS_TOKEN_HEADER"        = var.INCLUDE_ACCESS_TOKEN_HEADER

      "KV_CLIENT_ID"                       = var.KV_CLIENT_ID

      "KV_CLIENT_SECRET"                   = var.KV_CLIENT_SECRET

      "KV_TENANT_ID"                       = var.KV_TENANT_ID

      "KV_VAULT_NAME"                      = var.KV_VAULT_NAME

      "PF_ADAPTER_ID"                      = var.PF_ADAPTER_ID

      "PF_CLIENT_ID"                       = var.PF_CLIENT_ID

      "PF_LOGIN_URL"                       = var.PF_LOGIN_URL

      "PF_LOGOUT_URL"                      = var.PF_LOGOUT_URL

      "PF_SCOPE"                           = var.PF_SCOPE

      "PF_STATE"                           = var.PF_STATE

      "PF_TOKEN_URL"                       = var.PF_TOKEN_URL

      "PROXY_TARGET"                       = var.PROXY_TARGET

      "REDIS_HOST"                         = module.redis_cache.redis_hostname

      "REDIS_PORT"                         = "6380"

      "REDIS_TLS_SERVERNAME"               = module.redis_cache.redis_hostname

      "STARGATE_BASE_TOKEN_URL"            = var.STARGATE_BASE_TOKEN_URL

      "STARGATE_TARGET_PROXY_URL"          = var.STARGATE_TARGET_PROXY_URL

      "TENANT_LOGIN_REDIRECT_URL"          = var.TENANT_LOGIN_REDIRECT_URL

      "TENANT_LOGOUT_REDIRECT_URL"         = var.TENANT_LOGOUT_REDIRECT_URL

      "TENANT_SESSION_TTL"                 = var.TENANT_SESSION_TTL

      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

      "WEBSITES_PORT"                       = var.AUTH_PROXY_WEBSITES_PORT

   

  }

 

  site_config {

    always_on                 = true

    ftps_state                = "AllAllowed"

    http2_enabled             = false

    linux_fx_version          = var.proxy_linux_fx_version

    min_tls_version           = "1.2"

    use_32_bit_worker_process = true

    default_documents = [

      "Default.htm",

      "Default.html",

      "Default.asp",

      "index.htm",

      "index.html",

      "iisstart.htm",

      "default.aspx",

      "index.php",

      "hostingstart.html"

    ]

 

    cors {

      allowed_origins     = [""]

      support_credentials = false

    }

  }

 

  logs {

    http_logs {

      file_system {

        retention_in_days = 10

        retention_in_mb   = 35

      }

    }

  }

 

  identity {

    type = "SystemAssigned"

  }

  tags = local.auth

 

}

 

## WebApp-proxy Diagnostic Settings

 

resource "azurerm_monitor_diagnostic_setting" "proxy-diagnos" {

  name               = "${azurerm_app_service.main.name}-ds"

  target_resource_id = azurerm_app_service.Auth-proxy.id

  log_analytics_workspace_id = module.log_analytics_workspace.id

 

  log {

    category = "AppServiceHTTPLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

log {

    category = "AppServiceConsoleLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

log {

    category = "AppServiceAppLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

  log {

    category = "AppServiceFileAuditLogs"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

 

  log {

    category = "AppServiceAuditLogs"

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

 

/*## webapp proxy slot-B

 

resource "azurerm_app_service_slot" "Auth-proxy-slot" {

  name                    = "${local.resource_prefix}-Auth-proxy-app"

  app_service_name        = azurerm_app_service.main.name

  location                = var.location

  app_service_plan_id     = azurerm_app_service_plan.main.id

  resource_group_name     = module.main_resource_group.resource_group_name

  client_affinity_enabled = false

  //client_cert_enabled     = false

  https_only              = true

 

  app_settings = {

   

  }

 

  site_config {

    always_on                 = true

    ftps_state                = "AllAllowed"

    http2_enabled             = false

    linux_fx_version          = "${var.proxy_linux_fx_version}"

    min_tls_version           = "1.2"

    use_32_bit_worker_process = true

    default_documents = [

      "Default.htm",

      "Default.html",

      "Default.asp",

      "index.htm",

      "index.html",

      "iisstart.htm",

      "default.aspx",

      "index.php",

      "hostingstart.html"

    ]

 

    cors {

      allowed_origins     = [""]

      support_credentials = false

    }

  }

 

  logs {

    http_logs {

      file_system {

        retention_in_days = 10

        retention_in_mb   = 35

      }

    }

  }

 

  identity {

    type = "SystemAssigned"

  }

  tags = local.auth

 

}*/