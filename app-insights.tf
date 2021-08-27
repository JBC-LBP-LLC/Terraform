#
# Application Insights for WebApp
#

module "app_insights" {
  source              = ".//modules/app-insights"
  name                = "${local.resource_prefix}-unauth-apim"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "app_insights_auth" {
  source              = ".//modules/app-insights"
  name                = "${local.resource_prefix}-auth-apim"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "app_insights_UI" {
  source              = ".//modules/app-insights"
  name                = "${local.resource_prefix}-ui"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.auth
}

module "app_insights_proxy" {
  source              = ".//modules/app-insights"
  name                = "${local.resource_prefix}-proxy"
  resource_group_name = module.main_resource_group.resource_group_name
  location            = var.location
  tags                = local.auth
}