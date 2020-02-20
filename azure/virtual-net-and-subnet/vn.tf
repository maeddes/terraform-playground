variable "name" {}

provider "azurerm" {}

resource "azurerm_resource_group" "this" {
  name     = "${var.name}-resource-group"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}-virtual-net"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "this" {
  name                 = "${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefix       = "10.10.0.0/20"
  lifecycle {
    ignore_changes = ["route_table_id"]
  }
}