variable "name" {}
variable "resource_group" {}
variable "sp_client_id" {}
variable "sp_client_secret" {}

provider "azurerm" {
    #subscription_id = ARM_SUBSCRIPTION_ID
    #tenant_id       = ARM_TENANT_ID
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name}-k8s-cluster"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = var.resource_group
  dns_prefix          = "${var.name}-aks"
  #kubernetes_version  = "1.14.8"
  
  default_node_pool {
    name            = "worker"
    vm_size         = "Standard_DS2_v2"
    node_count      = 1
  #   os_disk_size_gb = 10
  }

  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }
 
}