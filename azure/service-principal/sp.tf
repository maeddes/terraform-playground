variable "name" {}
variable "sp_client_id" {}
variable "sp_client_secret" {}

resource "azuread_service_principal" "service_principal" {
  application_id = "${azuread_application.application.application_id}"
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

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kubernetes_version}"

  service_principal {
    client_id     = "${azuread_service_principal.service_principal.id}"
    client_secret = "${random_string.password.result}"
  }
  
}