variable "name" {}
variable "location" {}


provider "azurerm" {
    #subscription_id = ARM_SUBSCRIPTION_ID
    #tenant_id       = ARM_TENANT_ID
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azuread_application" "application" {
  name                       = "application"
  homepage                   = "http://homepage-${var.name}"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.application.application_id
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

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = "${var.name}-k8s-cluster"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "${var.name}-k8s-aks"
  
  default_node_pool {
    name            = "worker"
    vm_size         = "Standard_DS2_v2"
    node_count      = 1
  }

  service_principal {
    client_id     = azuread_service_principal.service_principal.application_id
    client_secret = azuread_service_principal_password.service_principal_password.value
  }
 
}

output "application" {
  value = azuread_application.application
}

output "service_principal" {
  value = azuread_service_principal.service_principal
}

output "service_principal_password" {
  value = azuread_service_principal_password.service_principal_password
}