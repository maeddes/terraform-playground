resource "azuread_application" "example" {
  name = "My First AzureAD Application"
}

resource "azuread_service_principal" "service_principal" {
  application_id = "${azuread_application.example.application_id}"
}

resource "random_string" "password" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = true
}

resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = "${azuread_service_principal.service_principal.id}"
  value                = "${random_string.password.result}"
  end_date_relative    = "8760h"
}

