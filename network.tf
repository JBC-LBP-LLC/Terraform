#

# Virtual Network Configuration

#

 

 

#

# Random Id Generator

#

resource "random_id" "rule1" {

  byte_length = 8

}

 

resource "random_id" "rule2" {

  byte_length = 8

}

 

resource "random_id" "rule3" {

  byte_length = 8

}

 

resource "random_id" "rule4" {

  byte_length = 8

}

 

#

# Virtual Network with DDOS-plan and 8 subnets

#

 

module "main_vnet" {

  source               = ".//modules/network"

  //location             = var.location

  virtual_network_name = "${local.resource_prefix}-vnet"

  resource_group_name  = module.main_resource_group.resource_group_name

  location            = var.location

  address_space        = [var.address_space]

  dns_servers          = null

  subnet_prefixes = ["172.${var.network_id}.16.0/20",

    "172.${var.network_id}.1.0/24",

    "172.${var.network_id}.2.0/24",

    "172.${var.network_id}.4.0/22",

    //"172.${var.network_id}.64.0/24",

    //"172.${var.network_id}.110.192/26",

    //"172.${var.network_id}.0.0/18",

    //"172.${var.network_id}.128.0/18",

    //"172.${var.network_id}.194.0/24",

    //"172.${var.network_id}.192.0/26",

    //"172.${var.network_id}.122.0/24"

 

  ]

  subnet_names = ["${var.platform_name}-auth-aks-subnet",

    "${var.platform_name}-apim-subnet",

    "${var.platform_name}-agw-subnet",

    "${var.platform_name}-unauth-aks-subnet",

    //"${var.platform_name}-aks-subnet",

    //"${var.platform_name}-cdb-subnet",

    //"AzureFirewallSubnet",

    //"${var.platform_name}-agw-subnet"

  ]

 

  #TODO: Enable DDoS

  # ddos_protection_plan {

  #   id     = azurerm_network_ddos_protection_plan.vnet-ddos-plan.id

  #   enable = false #Turn this off for now since it is incredibly expensive

  # }

 

  tags                     = local.tags

  subnet_service_endpoints = [["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"],["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"],["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"], ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]]

}

 

#

# Network Security Group for AKS

#

resource "azurerm_network_security_group" "aks-nsg" {

  name                = "${local.resource_prefix}-aks-nsg"

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

 

  #Inbound Rules

 

  security_rule {

    name                       = "Azure_Infrastructure_Load_Balancer"

    priority                   = 105

    direction                  = "Inbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = "*"

    source_address_prefix      = "AzureLoadBalancer"

    destination_address_prefix = "VirtualNetwork"

  }

 

    tags = local.tags

}

 

/*#TODO - Assoicate NSG to ASK Subnet

 

resource "azurerm_subnet_network_security_group_association" "aks-snet-nsg-association" {

  subnet_id                 = module.main_vnet.vnet_subnets[3]

  network_security_group_id = azurerm_network_security_group.aks-nsg.id

}

*/

#

# Network Security Group for APIM

#

resource "azurerm_network_security_group" "apim-nsg" {

  name                = "${local.resource_prefix}-apim-nsg"

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

 

  #Inbound Rules

 

  security_rule {

    name                       = "Client_Communication_to_API_Management"

    priority                   = 110

    direction                  = "Inbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = 80

    source_address_prefix      = "Internet"

    destination_address_prefix = "VirtualNetwork"

  }

 

  security_rule {

    name                       = "Management_endpoint_for_Azure_portal_and_Powershell"

    priority                   = 120

    direction                  = "Inbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = 3443

    source_address_prefix      = "ApiManagement"

    destination_address_prefix = "VirtualNetwork"

  }

 

  security_rule {

    name                       = "Secure_Client_Communication_to_API_Management"

    priority                   = 130

    direction                  = "Inbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = 443

    source_address_prefix      = "Internet"

    destination_address_prefix = "VirtualNetwork"

  }

 

  # Outbound Rules  need to add 12000, 1886" at line 170 and 443 at 183

 

 

  security_rule {

    name                       = "Dependency_on_Azure_Storage"

    priority                   = 100

    direction                  = "Outbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = 443

    source_address_prefix      = "VirtualNetwork"

    destination_address_prefix = "Storage"

    description                = "APIM service dependency on Azure Blob and Azure Table Storage"

  }

 

  security_rule {

    name                       = "Publish_DiagnosticLogs_And-Metrics"

    priority                   = 185

    direction                  = "Outbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = "443"

    source_address_prefix      = "VirtualNetwork"

    destination_address_prefix = "AzureMonitor"

    description                = "APIM Logs and Metrics for consumption by admins and your IT team are all part of the management plane"

  }

 

  security_rule {

    name                       = "Authenticate_To_Azure_Active_Directory"

    priority                   = 200

    direction                  = "Outbound"

    access                     = "Allow"

    protocol                   = "Tcp"

    source_port_range          = "*"

    destination_port_range     = "80"

    source_address_prefix      = "VirtualNetwork"

    destination_address_prefix = "AzureActiveDirectory"

    description                = ""

  }

 

 

    tags = local.tags

}

 

/*#TODO - Assoicate NSG to APIM Subnet

 

resource "azurerm_subnet_network_security_group_association" "apim-snet-nsg-association" {

  subnet_id                 = module.main_vnet.vnet_subnets[1]

  network_security_group_id = azurerm_network_security_group.apim-nsg.id

}*/

 

## Diagonstic settings

 

resource "azurerm_monitor_diagnostic_setting" "diagnostics-vnet" {

  name               = "diagnostics"

  target_resource_id = module.main_vnet.vnet_id

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

 

/*resource "azurerm_monitor_diagnostic_setting" "diagnostics-nsg" {

  name               = "diagnostics"

  target_resource_id = "${module.az_nsg.network_security_group_id}"

  storage_account_id = module.storage-account.storage_account_id

  log_analytics_workspace_id = "${azurerm_log_analytics_workspace.main.id}"

 

 

  log {

    category = "NetworkSecurityGroupEvent"

    enabled  = true

 

    retention_policy {

      enabled = true

      days = 90

    }

  }

 

  log {

    category = "NetworkSecurityGroupRuleCounter"

    enabled  = true

 

    retention_policy {

      enabled = true

      days = 90

    }

  }

 

  metric {

    category = "AllMetrics"

 

    retention_policy {

      enabled = true

      days = 90

    }

  }

}*/