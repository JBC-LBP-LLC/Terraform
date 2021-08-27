### Patient portal kv sp
/*data "azuread_service_principal" "spn" {
  display_name = var.display_name
}

resource "azurerm_key_vault_access_policy" "un_auth" {
   key_vault_id = module.key_vault.id
   tenant_id = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
   object_id = "${data.azuread_service_principal.spn.id}"
   secret_permissions = [
     "get", "list", "set", "delete", "recover", "backup", "restore"
   ]
}*/

data "azurerm_client_config" "current" {}

module "key_vault" {  
  source = ".//modules/key-vault"
  name                            = "${local.resource_prefix}unkv"
  resource_group_name             = module.main_resource_group.resource_group_name
  location            = var.location

  access_policies = [
    {
     object_ids = [azurerm_app_service.main.identity.0.principal_id]
     secret_permissions      = ["get", "list", "set", "delete", "recover", "backup", "restore"]
     key_permissions         = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
     certificate_permissions = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts","ManageIssuers","GetIssuers","ListIssuers","SetIssuers","DeleteIssuers"]
     certificate_permissions  = []
    }
  ]

  secrets = {
     "exacttarget-oauthcredentials-clientid"     = var.unkv-exacttarget-oauthcredentials-clientid
     "exacttarget-oauthcredentials-clientsecret" = var.unkv-exacttarget-oauthcredentials-clientsecret
     "exacttarget-granttype"                     = var.unkv-exacttarget-granttype
     "hemi-oauthcredentials-clientid"            = var.unkv-hemi-oauthcredentials-clientid
     "hemi-oauthcredentials-clientsecret"        = var.unkv-hemi-oauthcredentials-clientsecret
     "hemi-oauthcredentials-resource"            = var.unkv-hemi-oauthcredentials-resource
     "hemi-oauthcredentials-granttype"           = var.unkv-hemi-oauthcredentials-granttype
     "hemi-oauthurl"                              = var.unkv-hemi-oauthurl
     "redis-pw"                                  = module.redis_cache_UnAuth.redis_cache_primary_access_key 
     "redis-host"                                = module.redis_cache_UnAuth.redis_hostname            
     "redis-port"                                = "6380"
     "stargate-gateway-oauthurl"                 = var.unkv-stargate-gateway-oauthurl
     "stargate-oauthcredentials-clientid"        = var.unkv-stargate-oauthcredentials-clientid
     "stargate-oauthcredentials-clientsecret"    = var.unkv-stargate-oauthcredentials-clientsecret
     "stargate-oauthcredentials-granttype"       = var.unkv-stargate-oauthcredentials-granttype
    }

  tags = local.unauth
}

## Diagnostics for Key Vault
resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name               = "${local.resource_prefix}-kv-diagnostics"
  target_resource_id = module.key_vault.id
  //storage_account_id = module.storage-account.storage_account_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = true
      days = 90
    }
  }
}

## Auth Key vault
/*resource "azurerm_key_vault_access_policy" "auth" {
   key_vault_id = module.key_vault_auth.id
   tenant_id = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
   object_id = "${data.azuread_service_principal.spn.id}"
   secret_permissions = [
     "get", "list", "set", "delete", "recover", "backup", "restore"
   ]
}*/

module "key_vault_auth" {
  source = ".//modules/key-vault"
  name                            = "${local.resource_prefix}mskv"
  resource_group_name             = module.main_resource_group.resource_group_name
  location            = var.location

  access_policies = [
    {
     object_ids = [azurerm_app_service.main.identity.0.principal_id]
     secret_permissions      = ["get", "list", "set", "delete", "recover", "backup", "restore"]
     key_permissions         = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
     certificate_permissions = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts","ManageIssuers","GetIssuers","ListIssuers","SetIssuers","DeleteIssuers"]
    }
  ]

   secrets = {
      "dpaas-baseurl"                              = var.dpaas-baseurl
      "dpaas-detokenized-targeturl"                 = var.dpaas-detokenized-targeturl
      "dpaas-entiry"                               = var.dpaas-entiry
      "dpaas-source"                              = var.dpaas-source
      "dpaas-tokenized-targeturl"                     = var.dpaas-tokenized-targeturl
      "dpaas-user"                                   = var.dpaas-user
      "exacttarget-oauthcredentials-clientid"     = var.exacttarget-oauthcredentials-clientid
      "exacttarget-oauthcredentials-clientsecret"    = var.exacttarget-oauthcredentials-clientsecret
      "hemi-oauthcredentials-clientid"           = var.hemi-oauthcredentials-clientid
      "hemi-oauthcredentials-clientsecret"          = var.hemi-oauthcredentials-clientsecret
      "hemi-oauthcredentials-resource"           = var.hemi-oauthcredentials-resource
      "hemi-oauthurl"                              = var.hemi-oauthurl
      "ness-application-askId"                    = var.ness-application-askId
      "ness-application-name"                     = var.ness-application-name
      "ness-connection-url"                       = var.ness-connection-url
      "ness-device-vendor"                        = var.ness-device-vendor
      "OAuthUrl"                                       = var.OAuthUrl
      "patient-mysql-db-pw"                          = var.patient-mysql-db-pw
      "patient-mysql-db-url"                       = var.patient-mysql-db-url
      "patient-mysql-db-user"                      = var.patient-mysql-db-user
      "redis-host"                                   = module.redis_cache.redis_hostname
      "redis-port"                                   = 6380
      "redis-pw"                                       = module.redis_cache.redis_cache_primary_access_key
      "stargate-gateway-oauthurl"                     = var.stargate-gateway-oauthurl
      "stargate-oauthcredentials-clientid"          = var.stargate-oauthcredentials-clientid
      "stargate-oauthcredentials-clientsecret"         = var.stargate-oauthcredentials-clientsecret
      "stargate-oauthcredentials-granttype"       = var.stargate-oauthcredentials-granttype
  }

  tags = local.auth
}

## Diagnostics for auth-API Key Vault
resource "azurerm_monitor_diagnostic_setting" "diagnostics-api" {
  name               = "${local.resource_prefix}-kv-ds"
  target_resource_id = module.key_vault_auth.id
  //storage_account_id = module.storage-account.storage_account_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = true
      days = 90
    }
  }
}

## Key Vault for auth-UI
/*resource "azurerm_key_vault_access_policy" "auth-ui" {
   key_vault_id = module.key_vault_ui.id
   tenant_id = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
   object_id = "${data.azuread_service_principal.spn.id}"

   secret_permissions = [
     "get", "list", "set", "delete", "recover", "backup", "restore"
   ]
}*/

module "key_vault_ui" {
  source = ".//modules/key-vault"
  name                            = "${local.resource_prefix}uikv"
  resource_group_name             = module.main_resource_group.resource_group_name
  location            = var.location

  access_policies = [
    {
     object_ids = [azurerm_app_service.main.identity.0.principal_id]
     secret_permissions      = ["get", "list", "set", "delete", "recover", "backup", "restore"]
     key_permissions         = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
     certificate_permissions = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts","ManageIssuers","GetIssuers","ListIssuers","SetIssuers","DeleteIssuers"]
    }
  ]

    secrets = {
      "apim-client-id"         = var.apim-client-id
      "apim-client-secret"     = var.apim-client-secret
      "apim-resource"          = var.apim-resource
      "client-id"              = var.client-id
      "client-secret"          = var.client-secret
      "grant-type"             = var.grant-type
      "hemi-client-id"         = var.hemi-client-id
      "hemi-client-secret"     = var.hemi-client-secret
      "hemi-resource"          = var.hemi-resource
      "OAuthURL"               = var.OAuthURL
      "pf-client-secret"       = var.pf-client-secret
      "redis-password"         = module.redis_cache.redis_cache_primary_access_key
      "resource"               = var.resource
      "stargate-client-id"     = var.stargate-client-id
      "stargate-client-secret" = var.stargate-client-secret
  }

  tags = local.auth
}

## Diagnostics for auth-UI Key Vault
resource "azurerm_monitor_diagnostic_setting" "diagnostics-ui" {
  name               = "${local.resource_prefix}-kv-ds"
  target_resource_id = module.key_vault_ui.id

  //storage_account_id = module.storage-account.storage_account_id

  log_analytics_workspace_id = module.log_analytics_workspace.id

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = true
      days = 90
    }
  }
}