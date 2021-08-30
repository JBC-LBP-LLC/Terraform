
variable "server_name" {
    type = string
    description = "The name of the MySQL Server. Needs to be unique across Azure. Changing this forces a new resource to be created."
}

variable "location" {
    type = string
    description = "The Azure location where the resource should be created. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
    type = string
    description = "The Azure resource group to create the MySQL Server in. Changing this forces a new resource to be created."
}

variable "sku_name" {
    type = string
    description = "The sku name for the compute size for the MySQLServer."
}

variable "sku_capacity" {
    type = number
    description = "The scale up/out capacity for the MySQL Server."
}

variable "sku_tier" {
    type = string
    description = "The tier of the sku for the MySQL Server. Possible values are Basic, GeneralPurpose, and MemoryOptimized."
}

variable "sku_family" {
    type = string
    description = "The hardware family for the MySQL Server like Gen5."
}

variable "storage_in_mb" {
    type = number
    description = "The maximum storage allowed for the MySQL Server in megabytes."
}

variable "storage_backup_retention_days" {
    type = number
    description = "The number of days to keep database backups. Value must be between 7 and 35 days."
}

variable "storage_geo_redundant_backup" {
    type = string
    default = "false"
    description = "Enable or disable geo redundant backups for the server. Can be set to Enabled or Disabled."
}

variable "storage_auto_grow" {
    type = string
    default = "Disabled"
    description = "Enable or disable auto-growing of the databases. Can be set to Enabled or Disabled."
}

variable "administrator_login" {
    type = string
    description = "The administrator username for the MySQL Server."
}

variable "administrator_login_password" {
    type = string
    description = "The password for the administrator user."
}

variable "mysql_version" {
    type = string
    //default = "8.0"
    description = "The version of MySQL to use."
}

variable "ssl_enforcement" {
    type = string
    default = "Enabled"
    description = "Enable to require SSL access. Can be set to Enabled or Disabled."
}

variable "start_ip_address" {
    type = string
    default = "0.0.0.0"
    description = "The start of the ip range to allow access to the MySQL Server."
}

variable "end_ip_address" {
    type = string
    default = "0.0.0.0"
    description = "The end of the ip range to allow access to the MySQL Server."
}

variable "tags" {
    type = map
    description = "Any tags that should be applied to the MySQL Server."
}

variable "server_configuration_settings" {
    type = list
    default = []
    description = "Any MySQL Server connection settings that should be applied."
}

variable "firewall_rules" {
    type = list
    default = []
    description = "A list of firewall rules for the MySQL Server."
}

variable "network_rules" {
    type = list
    default = []
    description = "Any network rules for the MySQL Server. Can restrict access to specific subnets."
}

variable "databases" {
    type = list
    default = []
    description = "A list of databases that should be created on the MySQL Server."
}