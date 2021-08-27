#TODO - ADD APP INSIGHTS, monitoring log analytics workspace
module log_analytics_workspace {
  source              = ".//modules/log_analytics_workspace"
  name                = "${local.resource_prefix}-log"
  location            = var.location
  resource_group_name = module.main_resource_group.resource_group_name
  tags                = local.tags
}