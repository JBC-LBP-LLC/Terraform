# ---------------------------------------------------------------------------------------------------------------------

# Input variable definitions

# ---------------------------------------------------------------------------------------------------------------------

 

# The Azure region

variable "location" {

  type = string

}

 

## TAGS

 

variable "project" {

  type = string

}

 

variable "owner_name" {

 type = string

}

 

# Short form of Azure region, used for naming resources

variable "location_short" {

  type = string

}

 

# # Authentication to Azure AD to deploy resources

variable "client_id" {

  type = string

}

 

variable "client_secret" {}

 

# The Azure AD tenant to authenticate with

variable "tenant_id" {

  type = string

}

 

# The Azure subscription to deploy to

variable "subscription_id" {

  type = string

}

 

# The environment name, used for tagging resources

variable "environment_desc" {

  type = string

}

 

# Short form of environment, used for naming resources

variable "environment" {

  type = string

}

 

# Application or componentname, used for naming resources

variable "platform_name" {

  type = string

}

## Networking

 

# The address space for the main vnet

variable "address_space" {

  type = string

}

 

# The second octet of the ip address 172.x.0.0

variable "network_id" {

  type = string

}

 

## WebApp configs

 

variable "webapp_config_linux_fx_version" {

  type = string

}

 

## PROXY WEBAPP CONFIGS

 

variable "proxy_linux_fx_version" {

  type = string

}

 

#  Aks DNS prefix

variable "aks_dns_prefix" {

  type = string

}

 

# Aks Kubernetes version

variable "aks_k8s_version" {

  type = string

}

variable "aks_agent_pool_name" {

  type = string

}

variable "aks_agent_pool_node_min_count" {

  type = string

}

variable "aks_agent_pool_node_max_count" {

  type = string

}

variable "aks_agent_pool_node_count" {

  type = number

}

variable "aks_agent_pool_vm_size" {

  type = string

}

variable "aks_agent_pool_os_type" {

  type = string

}

variable "aks_agent_pool_os_disk_size_gb" {

  type = number

}

variable "aks_admin_username" {

  type = string

}

variable "aks_admin_password" {

  type = string

}

 

# AKS Vars for UnAuth cluster

 

variable "unauth_aks_agent_pool_name" {

  type = string

}

variable "unauth_aks_admin_username" {

  type = string

}

variable "unauth_aks_admin_password" {

  type = string

}

 

 

## APIM

 

 

variable "api_management_publisher_name" {

  type = string

}

variable "api_management_publisher_email" {

  type = string

}

variable "api_management_notification_sender_email" {

  type = string

}

variable "api_management_sku_name" {

  type = string

}

variable "api_management_sku_capacity" {

  type = number

}

 

## APIM service url's

 

variable "common-exacttargetemail-bxms-service-url" {

  type = string

}

variable "ctf-idcheck-service-url" {

  type = string

}

variable "ctf-refills-service-url" {

  type = string

}

variable "guestrefills-ua-bxms-service-url" {

  type = string

}

variable "unauth-specpat-rxorderdata-bxms-service-url" {

  type = string

}

 

variable "API-Health-Check-service-url" {

  type = string

}

variable "authproxy-url" {

  type = string

}

variable "common-address-bxms-service-url" {

  type = string

}

variable "common-paymentmethods-bxms-service-url" {

  type = string

}

variable "patientinformation-bxms-service-url" {

  type = string

}

variable "patient-paymententation-service-url" {

  type = string

}

variable "rx-order-data-service-url" {

  type = string

}

variable "specpat-hsiduser-bxms-service-url" {

  type = string

}

variable "specpat-prescriptions-bxms-service-url" {

  type = string

}

variable "specpat-upgoperations-bxms-service-url" {

  type = string

}

 

 

 

## MYSQL

 

variable "mysql_storage_backup_retention_days" {

  type = string

}

variable "mysql_storage_in_mb" {

  type = string

}

variable "mysql_sku_family" {

  type = string

}

variable "mysql_sku_tier" {

  type = string

}

variable "mysql_sku_capacity" {

  type = string

}

variable "mysql_sku_name" {

  type = string

}

variable "secret_mysql_administrator_login_password" {

  type = string

}

variable "secret_mysql_administrator_login" {

  type = string

}

 

 

 

## Redis Cache

 

variable "redis_capacity" {

  type = string

}

variable "redis_family" {

  type = string

}

variable "redis_sku_name" {

  type = string

}

 

###secrets variable###

#

#

#

 

//Application Gateway

 

variable "secret_cert_password" {

  type = string

}

variable "apim_host_name" {

  type = string

}

variable "certificate-path" {

  type = string

}

variable "public_ip_address_id" {

  type = string

}

variable "apim_backend_address_pool_ip_addresses" {

  type = string

}

 

variable "host_name_http_settings" {

  type = string

}

##########.......key vault credentials........########

 

variable "display_name" {

  type = string

}

# UnAuth_API_Key_Vault #

 

variable "unkv-exacttarget-oauthcredentials-clientid" {

  type = string

}

 

variable "unkv-exacttarget-oauthcredentials-clientsecret" {

  type = string

}

 

variable "unkv-exacttarget-granttype" {

  type = string

}

 

variable "unkv-hemi-oauthcredentials-clientid" {

  type = string

}

 

variable "unkv-hemi-oauthcredentials-clientsecret" {

  type = string

}

 

variable "unkv-hemi-oauthcredentials-resource" {

  type = string

}

 

variable "unkv-hemi-oauthcredentials-granttype" {

  type = string

}

 

variable "unkv-hemi-oauthurl" {

  type = string

}

 

variable "unkv-stargate-gateway-oauthurl" {

  type = string

}

 

variable "unkv-stargate-oauthcredentials-clientid" {

  type = string

}

 

variable "unkv-stargate-oauthcredentials-clientsecret" {

  type = string

}

 

variable "unkv-stargate-oauthcredentials-granttype" {

  type = string

}

 

# Auth_API_Key_Vault #

 

variable "dpaas-baseurl" {

  type = string

}

variable "dpaas-detokenized-targeturl" {

  type = string

}

variable "dpaas-entiry" {

  type = string

}

variable "dpaas-source" {

  type = string

}

variable "dpaas-tokenized-targeturl" {

 type = string

}

variable "dpaas-user" {

  type = string

}

variable "exacttarget-oauthcredentials-clientid" {

  type = string

}

variable "exacttarget-oauthcredentials-clientsecret" {

  type = string

}

variable "hemi-oauthcredentials-clientid" {

  type = string

}

variable "hemi-oauthcredentials-clientsecret" {

  type = string

}

variable "hemi-oauthcredentials-resource" {

  type = string

}

variable "hemi-oauthurl" {

  type = string

}

variable "ness-application-askId" {

  type = string

}

variable "ness-application-name" {

  type = string

}

variable "ness-connection-url" {

  type = string

}

variable "ness-device-vendor" {

  type = string

}

variable "OAuthUrl" {

  type = string

}

variable "patient-mysql-db-pw" {

  type = string

}

variable "patient-mysql-db-url" {

  type = string

}

variable "patient-mysql-db-user" {

  type = string

}

variable "stargate-gateway-oauthurl" {

  type = string

}

variable "stargate-oauthcredentials-clientid" {

  type = string

}

variable "stargate-oauthcredentials-clientsecret" {

  type = string

}

variable "stargate-oauthcredentials-granttype" {

  type = string

}

 

 

# Auth_UI_Key_Vault #

 

variable "apim-client-id" {

  type = string

}

variable "apim-client-secret" {

  type = string

}

variable "apim-resource" {

  type = string

}

variable "client-id" {

  type = string

}

variable "client-secret" {

  type = string

}

variable "grant-type" {

  type = string

}

variable "hemi-client-id" {

  type = string

}

variable "hemi-client-secret" {

  type = string

}

variable "hemi-resource" {

  type = string

}

variable "OAuthURL" {

  type = string

}

variable "pf-client-secret" {

  type = string

}

variable "resource" {

  type = string

}

variable "stargate-client-id" {

  type = string

}

variable "stargate-client-secret" {

  type = string

}

 

## webapp/UI vars

 

variable "APP_ENV" {

  type = string

}

variable "AZURE_TENANT_ID" {

  type = string

}

variable "AZURE_VAULT_CLIENT_ID" {

  type = string

}

variable "AZURE_VAULT_CLIENT_SECRET" {

  type = string

}

variable "AZURE_VAULT_NAME" {

  type = string

}

variable "DOCKER_REGISTRY_SERVER_PASSWORD" {

  type = string

}

variable "DOCKER_REGISTRY_SERVER_URL" {

  type = string

}

variable "DOCKER_REGISTRY_SERVER_USERNAME" {

  type = string

}

variable "HSID_LOGOUT_URL" {

  type = string

}

variable "LOGIN_URL" {

  type = string

}

variable "SESSION_TIMEOUT" {

  type = string

}

variable "WEBSITES_PORT" {

  type = string

}

 

## webapp/Auth_proxy vars

 

variable "APIM_BASE_TOKEN_URL" {

  type = string

}

variable "APIM_SUBJECT_HEADER_NAME" {

  type = string

}

variable "APIM_TARGET_PROXY_URL" {

  type = string

}

variable "CORS_ALLOWED_HEADERS" {

  type = string

}

variable "CORS_ALLOWED_ORIGINS" {

  type = string

}

variable "DATA_PROVIDER_NAMES" {

  type = string

}

variable "HEMI_BASE_TOKEN_URL" {

  type = string

}

variable "HEMI_TARGET_PROXY_URL" {

  type = string

}

variable "INCLUDE_ACCESS_TOKEN_HEADER" {

  type = string

}

variable "KV_CLIENT_ID" {

  type = string

}

variable "KV_CLIENT_SECRET" {

  type = string

}

variable "KV_TENANT_ID" {

  type = string

}

variable "KV_VAULT_NAME" {

  type = string

}

variable "PF_ADAPTER_ID" {

  type = string

}

variable "PF_CLIENT_ID" {

  type = string

}

variable "PF_LOGIN_URL" {

  type = string

}

variable "PF_LOGOUT_URL" {

  type = string

}

variable "PF_SCOPE" {

  type = string

}

variable "PF_STATE" {

  type = string

}

variable "PF_TOKEN_URL" {

  type = string

}

variable "PROXY_TARGET" {

  type = string

}

variable "STARGATE_BASE_TOKEN_URL" {

  type = string

}

variable "STARGATE_TARGET_PROXY_URL" {

  type = string

}

variable "TENANT_LOGIN_REDIRECT_URL" {

  type = string

}

variable "TENANT_LOGOUT_REDIRECT_URL" {

  type = string

}

variable "TENANT_SESSION_TTL" {

  type = string

}

variable "AUTH_PROXY_WEBSITES_PORT" {

  type = string

}
