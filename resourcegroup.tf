# ---------------------------------------------------------------------------------------------------------------------
# Terraform deployment file for Skyline-Projects
# ---------------------------------------------------------------------------------------------------------------------

#
# Local Variables
#

locals {
  # Naming prefix for resources using platform, environment, and location
  resource_prefix = "${var.platform_name}-${var.environment}-${var.location_short}"

  # Tags to include on each resource
  tags = {
    Project     = var.project
    Environment = var.environment_desc
    "Owner Name"  = var.owner_name
    Terraform   = true
  }

  auth = {
    Project     = "Specialty-Patient-Auth"
    Environment = var.environment_desc
    "Owner Name"  = var.owner_name
    Terraform   = true
  }

  unauth = {
    Project     = "Specialty-Patient-unAuth"
    Environment = var.environment_desc
    "Owner Name"  = var.owner_name
    Terraform   = true
  }
}