### AKS cluster

 

resource "azurerm_kubernetes_cluster" "unauth_aks" {

  name                = "${local.resource_prefix}-unAuth-aks"

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

  dns_prefix          = var.aks_dns_prefix

  api_server_authorized_ip_ranges = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23", "198.203.176.0/22", "198.203.180.0/23"]

  kubernetes_version  = var.aks_k8s_version

  node_resource_group = "aks-unauth-${module.main_resource_group.resource_group_name}"

  default_node_pool {

    name            = var.unauth_aks_agent_pool_name

    enable_auto_scaling = true

    type            = "VirtualMachineScaleSets"

    node_count      = var.aks_agent_pool_node_count

    min_count       = var.aks_agent_pool_node_min_count

    max_count       = var.aks_agent_pool_node_max_count

    vm_size         = var.aks_agent_pool_vm_size

    os_disk_size_gb = var.aks_agent_pool_os_disk_size_gb

    vnet_subnet_id  = module.main_vnet.vnet_subnets[3]

  }

 

  network_profile {

    network_plugin = "azure"

    load_balancer_sku = "Standard"

  }

 

  role_based_access_control {

      enabled = true

  }

 

  service_principal {

    client_id     = var.client_id

    client_secret = var.client_secret

  }

 

windows_profile {

   admin_username = var.unauth_aks_admin_username

   admin_password  = var.unauth_aks_admin_password

  }

 

  addon_profile {

    kube_dashboard {

        enabled                    = true

    }

    oms_agent {

      enabled                    = true

      log_analytics_workspace_id = module.log_analytics_workspace.id

    }

  }

 tags = local.unauth

}

 

 

## AKS Diagnostic Settings

 

resource "azurerm_monitor_diagnostic_setting" "aks-unauth-diagnos" {

  name               = "${azurerm_kubernetes_cluster.unauth_aks.name}-daignostics"

  target_resource_id = azurerm_kubernetes_cluster.unauth_aks.id

  log_analytics_workspace_id = module.log_analytics_workspace.id

 

  log {

    category = "kube-apiserver"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

  log {

    category = "kube-controller-manager"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

 

 

  } 

  log {

    category = "kube-scheduler"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

 

  } 

 

  log {

    category = "kube-audit"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

 

  }

 

  log {

    category = "cluster-autoscaler"

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

 

 

## Kubernetes cluster for Auth-cluster

resource "azurerm_kubernetes_cluster" "aks_auth" {

  name                = "${local.resource_prefix}-auth-aks"

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

  dns_prefix          = var.aks_dns_prefix

  api_server_authorized_ip_ranges = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23", "198.203.176.0/22", "198.203.180.0/23"]

  kubernetes_version  = var.aks_k8s_version

  node_resource_group = "aks-auth-${module.main_resource_group.resource_group_name}"

  default_node_pool {

    name            = var.aks_agent_pool_name

    enable_auto_scaling = true

    type            = "VirtualMachineScaleSets"

    node_count      = var.aks_agent_pool_node_count

    min_count       = var.aks_agent_pool_node_min_count

    max_count       = var.aks_agent_pool_node_max_count

    vm_size         = var.aks_agent_pool_vm_size

    os_disk_size_gb = var.aks_agent_pool_os_disk_size_gb

    vnet_subnet_id  = module.main_vnet.vnet_subnets[0]

  }

 

  network_profile {

    network_plugin = "azure"

    load_balancer_sku = "Standard"

  }

 

  role_based_access_control {

      enabled = true

  }

 

  service_principal {

    client_id     = var.client_id

    client_secret = var.client_secret

  }

 

windows_profile {

   admin_username = var.unauth_aks_admin_username

   admin_password  = var.unauth_aks_admin_password

  }

 

  addon_profile {

    kube_dashboard {

        enabled                    = true

    }

    oms_agent {

      enabled                    = true

      log_analytics_workspace_id = module.log_analytics_workspace.id

    }

  }

 tags = local.auth

}

 

 

## AKS Diagnostic Settings

 

resource "azurerm_monitor_diagnostic_setting" "aks-auth-diagnos" {

  name               = "${azurerm_kubernetes_cluster.aks_auth.name}-daignostics"

  target_resource_id = azurerm_kubernetes_cluster.aks_auth.id

  log_analytics_workspace_id = module.log_analytics_workspace.id

 

  log {

    category = "kube-apiserver"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

  }

  log {

    category = "kube-controller-manager"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

 

 

  } 

  log {

    category = "kube-scheduler"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

 

  } 

 

  log {

    category = "kube-audit"

    enabled  = true

 

    retention_policy {

      enabled = false

    }

 

  }

 

  log {

    category = "cluster-autoscaler"

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