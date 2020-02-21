resource "azuread_application" "sp" {
  name                       = "sp"
  homepage                   = "http://homepage"
  identifier_uris            = ["http://uri"]
  reply_urls                 = ["http://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.sp.application_id
}

resource "random_string" "password" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = true
}

resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = azuread_service_principal.service_principal.id
  value                = random_string.password.result
  end_date_relative    = "8760h"
}

output "application" {
  value = azuread_application.sp
}

output "service_principal" {
  value = azuread_service_principal.service_principal
}

output "service_principal_password" {
  value = azuread_service_principal_password.service_principal_password
}