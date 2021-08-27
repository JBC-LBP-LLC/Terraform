locals {

  apim_name                       = "${local.resource_prefix}-api"

  apim_logger                     = "${local.resource_prefix}-logger"

}

 

#

# Api Management

#

 

 

resource "azurerm_api_management" "apim" {

  name                = local.apim_name

  location            = var.location

  resource_group_name = module.main_resource_group.resource_group_name

  publisher_name      = var.api_management_publisher_name

  publisher_email     = var.api_management_publisher_email

 

  notification_sender_email = var.api_management_notification_sender_email

  sku_name                  = "${var.api_management_sku_name}_${var.api_management_sku_capacity}"

 

 

  virtual_network_type = "Internal"

  virtual_network_configuration {

      subnet_id = module.main_vnet.vnet_subnets[1]

  }


 

  security {

    enable_backend_ssl30 = false

    enable_backend_tls10 = false

    enable_backend_tls11 = false

 

    enable_frontend_ssl30 = false

    enable_frontend_tls10 = false

    enable_frontend_tls11 = false

 

    enable_triple_des_ciphers = false

  }

 

  tags = local.tags

}

 

resource "azurerm_api_management_custom_domain" "custom-domain" {

  api_management_id = azurerm_api_management.apim.id

 

  proxy {

          host_name = "prf-eastsrxpatientapi.optum.com"

          certificate = filebase64(var.certificate-path)

          certificate_password  = var.secret_cert_password

        }

}

 

#

# common-exacttargetemail-bxms/API

#

resource "azurerm_api_management_api" "common-exacttargetemail-bxms" {

  name                = "common-exacttargetemail-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "common-exacttargetemail-bxms"

  path                = "exact-targetmail-service"

  protocols           = ["https"]

  service_url         = var.common-exacttargetemail-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_policy" "api_policy_inbound" {

  api_name            = azurerm_api_management_api.common-exacttargetemail-bxms.name

  api_management_name = azurerm_api_management_api.common-exacttargetemail-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  xml_content         = file("./prf/certs/AllOperations.xml")

}

 

resource "azurerm_api_management_api_operation" "post_sendemail" {

  operation_id        = "SendMail"

  api_name            = azurerm_api_management_api.common-exacttargetemail-bxms.name

  api_management_name = azurerm_api_management_api.common-exacttargetemail-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "sendmail"

  method              = "POST"

  url_template        = "/api/specialty/common/exacttarget/email/send/"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

#

# ctf-idcheck/API

#

resource "azurerm_api_management_api" "ctf-idcheck" {

  name                = "ctf-idcheck"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "ctf-idcheck"

  path                = "ctf-idcheck"

  protocols           = ["https"]

  service_url         = var.ctf-idcheck-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_policy" "policy_inbound" {

  api_name            = azurerm_api_management_api.ctf-idcheck.name

  api_management_name = azurerm_api_management_api.ctf-idcheck.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  xml_content         = file("./prf/certs/AllOperations.xml")

}

 

resource "azurerm_api_management_api_operation" "post_identitycheck-v1" {

  operation_id        = "identitycheck-v1"

  api_name            = azurerm_api_management_api.ctf-idcheck.name

  api_management_name = azurerm_api_management_api.ctf-idcheck.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "identitycheck-v1"

  method              = "POST"

  url_template        = "/api/specialty/patient/identitycheck/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

resource "azurerm_api_management_api_operation" "get_msgidstatus-v1" {

  operation_id        = "msgidstatus-v1"

  api_name            = azurerm_api_management_api.ctf-idcheck.name

  api_management_name = azurerm_api_management_api.ctf-idcheck.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "msgidstatus-v1"

  method              = "GET"

  url_template        = "/api/specialty/patient/msgidstatus/v1/*"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

#

# ctf-refills/API

#

resource "azurerm_api_management_api" "ctf-refills" {

  name                = "ctf-refills"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "ctf-refills"

  path                = "ctf-refills"

  protocols           = ["https"]

  service_url         = var.ctf-refills-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_policy" "policy-ctf-refills" {

  api_name            = azurerm_api_management_api.ctf-refills.name

  api_management_name = azurerm_api_management_api.ctf-refills.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  xml_content         = file("./prf/certs/AllOperations.xml")

}

 

resource "azurerm_api_management_api_operation" "post_availablerefills-v1" {

  operation_id        = "availablerefills-v1"

  api_name            = azurerm_api_management_api.ctf-refills.name

  api_management_name = azurerm_api_management_api.ctf-refills.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "availablerefills-v1"

  method              = "POST"

  url_template        = "/api/specialty/patient/availablerefills/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

#

# guestrefills-ua-bxms/API

#

resource "azurerm_api_management_api" "guestrefills-ua-bxms" {

  name                = "guestrefills-ua-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "guestrefills-ua-bxms"

  path                = "guest-refills"

  protocols           = ["https"]

  service_url         = var.guestrefills-ua-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_policy" "policy-guestrefills-ua-bxms" {

  api_name            = azurerm_api_management_api.guestrefills-ua-bxms.name

  api_management_name = azurerm_api_management_api.guestrefills-ua-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  xml_content         = file("./prf/certs/AllOperations.xml")

}

 

resource "azurerm_api_management_api_operation" "guest-refills" {

  operation_id        = "guest-refills"

  api_name            = azurerm_api_management_api.guestrefills-ua-bxms.name

  api_management_name = azurerm_api_management_api.guestrefills-ua-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "guest-refills"

  method              = "POST"

  url_template        = "/api/specialty/patient/guestrefills/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

resource "azurerm_api_management_api_operation" "guest-refills-logger" {

  operation_id        = "guest-refills-logger"

  api_name            = azurerm_api_management_api.guestrefills-ua-bxms.name

  api_management_name = azurerm_api_management_api.guestrefills-ua-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "guest-refills-logger"

  method              = "POST"

  url_template        = "/api/specialty/patient/actuator/loggers/com.optum.specialty"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

#

# unauth-specpat-rxorderdata-bxms/API

#

resource "azurerm_api_management_api" "unauth-specpat-rxorderdata-bxms" {

  name                = "unauth-specpat-rxorderdata-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "unauth-specpat-rxorderdata-bxms"

  path                = "unauth-specpat-rxorderdata-bxms"

  protocols           = ["https"]

  service_url         = var.unauth-specpat-rxorderdata-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_policy" "policy-unauth-specpat-rxorderdata-bxms" {

  api_name            = azurerm_api_management_api.unauth-specpat-rxorderdata-bxms.name

  api_management_name = azurerm_api_management_api.unauth-specpat-rxorderdata-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  xml_content         = file("./prf/certs/AllOperations.xml")

}

 

resource "azurerm_api_management_api_operation" "getRXOrderData" {

  operation_id        = "getRXOrderData"

  api_name            = azurerm_api_management_api.unauth-specpat-rxorderdata-bxms.name

  api_management_name = azurerm_api_management_api.unauth-specpat-rxorderdata-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getRXOrderData"

  method              = "POST"

  url_template        = "/api/specialty/patient/rxorderdata/mock"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

resource "azurerm_api_management_api_operation" "getRXDetail" {

  operation_id        = "getRXDetail"

  api_name            = azurerm_api_management_api.unauth-specpat-rxorderdata-bxms.name

  api_management_name = azurerm_api_management_api.unauth-specpat-rxorderdata-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getRXDetail"

  method              = "POST"

  url_template        = "/api/specialty/patient/rxorderdata/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

 

##############################################################################################################################

##############################################################################################################################

##############################################################################################################################

 

##..........AUTH_API'S...........##

 

#

# API Health Check/API

#

resource "azurerm_api_management_api" "API_Health_Check" {

  name                = "API-Health-Check"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "API-Health-Check"

  path                = "health"

  protocols           = ["https"]

  //service_url         = var.API-Health-Check-service-url

  subscription_required = false

 

}

 

 

resource "azurerm_api_management_api_operation" "check" {

  operation_id        = "check"

  api_name            = azurerm_api_management_api.API_Health_Check.name

  api_management_name = azurerm_api_management_api.API_Health_Check.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "check"

  method              = "GET"

  url_template        = "/check"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

#

# auth-proxy/API

#

resource "azurerm_api_management_api" "auth-proxy" {

  name                = "auth-proxy"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-proxy"

  path                = "authproxy"

  protocols           = ["https"]

  service_url         = var.authproxy-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_policy" "policy-auth-proxy" {

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  xml_content         = file("./prf/certs/AuthProxyOperations.xml")

}

 

resource "azurerm_api_management_api_operation" "login" {

  operation_id        = "login"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "login"

  method              = "GET"

  url_template        = "/login"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "logout" {

  operation_id        = "logout"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "logout"

  method              = "POST"

  url_template        = "/logout"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "refresh" {

  operation_id        = "refresh"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "refresh"

  method              = "PUT"

  url_template        = "/refresh"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "secure-delete" {

  operation_id        = "secure-delete"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "secure-delete"

  method              = "DELETE"

  url_template        = "/secure/*"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "secure-get" {

  operation_id        = "secure-get"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "secure-get"

  method              = "GET"

  url_template        = "/secure/*"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "secure-post" {

  operation_id        = "secure-post"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "secure-post"

  method              = "POST"

  url_template        = "/secure/*"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "Secure-PUT" {

  operation_id        = "secure-put"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "secure-put"

  method              = "PUT"

  url_template        = "/secure/*"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "session" {

  operation_id        = "session"

  api_name            = azurerm_api_management_api.auth-proxy.name

  api_management_name = azurerm_api_management_api.auth-proxy.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "session"

  method              = "POST"

  url_template        = "/session"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

### AUTH_API'S ####

 

#

# common-address-bxms/API

#

resource "azurerm_api_management_api" "common-address-bxms" {

  name                = "auth-common-address-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-common-address-bxms"

  path                = "common-address-service"

  protocols           = ["https"]

  service_url         = var.common-address-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "addPatientAddressmock" {

  operation_id        = "addPatientAddressmock"

  api_name            = azurerm_api_management_api.common-address-bxms.name

  api_management_name = azurerm_api_management_api.common-address-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "addPatientAddressmock"

  method              = "POST"

  url_template        = "/api/specialty/address/mock"

  description         = "addPatientAddressUsingPOST"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "addPatientAddressv1" {

  operation_id        = "addPatientAddress"

  api_name            = azurerm_api_management_api.common-address-bxms.name

  api_management_name = azurerm_api_management_api.common-address-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "addPatientAddress"

  method              = "POST"

  url_template        = "/api/specialty/address/add/v1"

  description         = "addPatientAddressUsingPOST_1"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "updatePatientAddress" {

  operation_id        = "updatePatientAddress"

  api_name            = azurerm_api_management_api.common-address-bxms.name

  api_management_name = azurerm_api_management_api.common-address-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "updatePatientAddress"

  method              = "PUT"

  url_template        = "/api/specialty/address/update/v1"

  description         = "updatePatientAddress-updatePatientAddress"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "updatePatientAddressUsingPUT" {

  operation_id        = "updatePatientAddressUsingPUT"

  api_name            = azurerm_api_management_api.common-address-bxms.name

  api_management_name = azurerm_api_management_api.common-address-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "addPatientAddress"

  method              = "PUT"

  url_template        = "/api/specialty/address/mock"

  description         = "updatePatientAddress"

 

  response {

    status_code = 200

  }

}

 

#

# common-paymentmethods-bxms/API

#

resource "azurerm_api_management_api" "common-paymentmethods-bxms" {

  name                = "auth-common-paymentmethods-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-common-paymentmethods-bxms"

  path                = "payment-methods"

  protocols           = ["https"]

  service_url         = var.common-paymentmethods-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "addPaymentMethods" {

  operation_id        = "addPaymentMethodsUsingPOST"

  api_name            = azurerm_api_management_api.common-paymentmethods-bxms.name

  api_management_name = azurerm_api_management_api.common-paymentmethods-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "addPaymentMethods"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/payment/methods/add/v1"

  description         = "addPaymentMethods"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "getPaymentMethods" {

  operation_id        = "getPaymentMethods"

  api_name            = azurerm_api_management_api.common-paymentmethods-bxms.name

  api_management_name = azurerm_api_management_api.common-paymentmethods-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getPaymentMethods"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/payment/methods/mock"

  description         = "getPaymentMethods"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "getPaymentMethodsv1" {

  operation_id        = "getPaymentMethodsUsingPOST"

  api_name            = azurerm_api_management_api.common-paymentmethods-bxms.name

  api_management_name = azurerm_api_management_api.common-paymentmethods-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getPaymentMethods"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/payment/methods/get/v1"

  description         = "getPaymentMethods"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "patientPaymentMethodDelete" {

  operation_id        = "patientPaymentMethodDelete"

  api_name            = azurerm_api_management_api.common-paymentmethods-bxms.name

  api_management_name = azurerm_api_management_api.common-paymentmethods-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "patientPaymentMethodDelete"

  method              = "DELETE"

  url_template        = "/api/specialty/common/patient/payment/methods/v1"

  description         = "patientPaymentMethodDelete"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "updatePaymentMethodsUsingPUT" {

  operation_id        = "updatePaymentMethodsUsingPUT"

  api_name            = azurerm_api_management_api.common-paymentmethods-bxms.name

  api_management_name = azurerm_api_management_api.common-paymentmethods-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "updatePaymentMethods"

  method              = "PUT"

  url_template        = "/api/specialty/common/patient/payment/methods/update/v1"

  description         = "updatePaymentMethods"

 

  response {

    status_code = 200

  }

}

 

 

#

# patientinformation-bxms/API

#

resource "azurerm_api_management_api" "patientinformation-bxms" {

  name                = "auth-patientinformation-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-patientinformation-bxms"

  path                = "patient-information"

  protocols           = ["https"]

  service_url         = var.patientinformation-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "getPatientInfo" {

  operation_id        = "getPatientInfo"

  api_name            = azurerm_api_management_api.patientinformation-bxms.name

  api_management_name = azurerm_api_management_api.patientinformation-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getPatientInfo"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/info/v1"

  description         = "getPatientInfo"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "getPatientInfomock" {

  operation_id        = "getPatientInfomock"

  api_name            = azurerm_api_management_api.patientinformation-bxms.name

  api_management_name = azurerm_api_management_api.patientinformation-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getPatientInfo"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/info/mock"

  description         = "getPatientInfo"

 

  response {

    status_code = 200

  }

}

 

 

#

# patient-paymententation-bxms/API

#

resource "azurerm_api_management_api" "patient-paymententation" {

  name                = "auth-patient-paymententation"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-patient-paymententation"

  path                = "common-patientpayment"

  protocols           = ["https"]

  service_url         = var.patient-paymententation-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "getBalanceDue" {

  operation_id        = "getBalanceDue"

  api_name            = azurerm_api_management_api.patient-paymententation.name

  api_management_name = azurerm_api_management_api.patient-paymententation.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getBalanceDue"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/payment/getbalancedue/v1"

  description         = "getBalanceDue"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "getBalanceDueMock" {

  operation_id        = "getBalanceDueMock"

  api_name            = azurerm_api_management_api.patient-paymententation.name

  api_management_name = azurerm_api_management_api.patient-paymententation.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getBalanceDueMock"

  method              = "POST"

  url_template        = "/getbalancedue/mock"

  description         = "getBalanceDueMock"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "makePayment" {

  operation_id        = "makePayment"

  api_name            = azurerm_api_management_api.patient-paymententation.name

  api_management_name = azurerm_api_management_api.patient-paymententation.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "makePayment"

  method              = "POST"

  url_template        = "/api/specialty/common/patient/payment/makepayment/v1"

  description         = "makePayment"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "makePaymentMock" {

  operation_id        = "makePaymentMock"

  api_name            = azurerm_api_management_api.patient-paymententation.name

  api_management_name = azurerm_api_management_api.patient-paymententation.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "makePaymentMock"

  method              = "POST"

  url_template        = "/makepayment/mock"

  description         = "makePaymentMock"

 

  response {

    status_code = 200

  }

}

 

 

 

#

# rx-order-data-bxms/API

#

resource "azurerm_api_management_api" "rx-order-data" {

  name                = "auth-rx-order-data"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-rx-order-data"

  path                = "order-data"

  protocols           = ["https"]

  service_url         = var.rx-order-data-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "getRXDetail_Auth" {

  operation_id        = "getRXDetail"

  api_name            = azurerm_api_management_api.rx-order-data.name

  api_management_name = azurerm_api_management_api.rx-order-data.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getRXDetail"

  method              = "POST"

  url_template        = "/api/specialty/patient/rxorderdata/v1"

  description         = "getRXDetail"

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "getRXOrderData_Auth" {

  operation_id        = "getRXOrderData"

  api_name            = azurerm_api_management_api.rx-order-data.name

  api_management_name = azurerm_api_management_api.rx-order-data.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getRXOrderData"

  method              = "POST"

  url_template        = "/api/specialty/patient/rxorderdata/mock"

  description         = "getRXOrderData"

 

  response {

    status_code = 200

  }

}

 

#

# specpat-hsiduser-bxms/API

#

resource "azurerm_api_management_api" "specpat-hsiduser-bxms" {

  name                = "auth-specpat-hsiduser-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-specpat-hsiduser-bxms"

  path                = "hsiduser-service"

  protocols           = ["https"]

  service_url         = var.specpat-hsiduser-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "accmgmt" {

  operation_id        = "accmgmt"

  api_name            = azurerm_api_management_api.specpat-hsiduser-bxms.name

  api_management_name = azurerm_api_management_api.specpat-hsiduser-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "accmgmt"

  method              = "POST"

  url_template        = "/api/specialty/patient/profile/accMgmt/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

resource "azurerm_api_management_api_operation" "getHSIDPatientProfile" {

  operation_id        = "getHSIDPatientProfile"

  api_name            = azurerm_api_management_api.specpat-hsiduser-bxms.name

  api_management_name = azurerm_api_management_api.specpat-hsiduser-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getHSIDPatientProfile"

  method              = "POST"

  url_template        = "/api/specialty/patient/profile/v1"

  description         = "getRXOrderData"

 

  response {

    status_code = 200

  }

}

 

 

#

# specpat-prescriptions-bxms/API

#

resource "azurerm_api_management_api" "specpat-prescriptions-bxms" {

  name                = "auth-specpat-prescriptions-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-specpat-prescriptions-bxms"

  path                = "specpat-prescriptions"

  protocols           = ["https"]

  service_url         = var.specpat-prescriptions-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "prescriptions" {

  operation_id        = "prescriptions"

  api_name            = azurerm_api_management_api.specpat-prescriptions-bxms.name

  api_management_name = azurerm_api_management_api.specpat-prescriptions-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "prescriptions"

  method              = "POST"

  url_template        = "/api/specialty/patient/prescriptions/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

 

 

#

# specpat-upgoperations-bxms/API

#

resource "azurerm_api_management_api" "specpat-upgoperations-bxms" {

  name                = "auth-specpat-upgoperations-bxms"

  resource_group_name = module.main_resource_group.resource_group_name

  api_management_name = azurerm_api_management.apim.name

  revision            = "1"

  description         = ""

  display_name        = "auth-specpat-upgoperations-bxms"

  path                = "specpat-upgoperations"

  protocols           = ["https"]

  service_url         = var.specpat-upgoperations-bxms-service-url

  subscription_required = false

 

}

 

resource "azurerm_api_management_api_operation" "getUPGAddCardURL" {

  operation_id        = "getUPGAddCardURL"

  api_name            = azurerm_api_management_api.specpat-upgoperations-bxms.name

  api_management_name = azurerm_api_management_api.specpat-upgoperations-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "getUPGAddCardURL"

  method              = "POST"

  url_template        = "/api/specialty/patient/add/card/url/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

resource "azurerm_api_management_api_operation" "upgAddCard" {

  operation_id        = "upgAddCard"

  api_name            = azurerm_api_management_api.specpat-upgoperations-bxms.name

  api_management_name = azurerm_api_management_api.specpat-upgoperations-bxms.api_management_name

  resource_group_name = module.main_resource_group.resource_group_name

  display_name        = "upgAddCard"

  method              = "POST"

  url_template        = "/api/specialty/patient/add/card/v1"

  description         = ""

 

  response {

    status_code = 200

  }

}

 

 

 

 

 

resource "azurerm_api_management_logger" "apim-logger" {

  name                = local.apim_logger

  api_management_name = azurerm_api_management.apim.name

  resource_group_name = module.main_resource_group.resource_group_name

 

  application_insights {

    instrumentation_key = module.app_insights.instrumentation_key

  }

}

 

## APIM Diagnostic Settings

 

resource "azurerm_monitor_diagnostic_setting" "apim-diagnos" {

  name               = "${azurerm_api_management.apim.name}-diagnostic"

  target_resource_id = azurerm_api_management.apim.id

  log_analytics_workspace_id = module.log_analytics_workspace.id

 

  log {

    category = "GatewayLogs"

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