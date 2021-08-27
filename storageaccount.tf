#
# Storage ccount with Fileshare and Blob storage.
#

module storage-account {
  source                            = .modulesstorage-account
  name                              = ${local.resource_prefix}-sto
  resource_group_name               = module.main_resource_group.resource_group_name
  location                          = var.location
  account_tier                      = Standard
  account_replication_type          = LRS
  enable_https_traffic_only         = true
  enable_advanced_threat_protection = true
  file_share_names = [clicktofillidcheck-ua-bxms, clicktofillrefills-ua-bxms, common-exacttargetemail-bxms, unauth-specpat-rxorderdata-bxms, guestrefills-ua-bxms, common-address-bxms, common-patientinformation-bxms, common-patientpayment-bxms, common-paymentmethods-bxms, specpat-hsiduser-bxms, specpat-prescriptions-bxms, specpat-rxorderdata-bxms, specpat-upgoperations-bxms]
  file_share_quotas = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  tags = local.tags
}