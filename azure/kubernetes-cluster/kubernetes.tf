variable "name" {}
variable "sp_client_id" {}
variable "sp_client_secret" {}

resource "azurerm_resource_group" "this" {
  name     = "${var.name}-aks"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "this" {
  name                 = "${var.name}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefix       = "10.10.0.0/20"
  lifecycle {
    ignore_changes = ["route_table_id"]
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name}-aks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  kubernetes_version  = "1.14.8"
  dns_prefix          = var.name
  
  default_node_pool {
    name            = "minion"
    vm_size         = "Standard_D4s_v3"
    node_count      = 2
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.this.id
  }
 
   service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }
}