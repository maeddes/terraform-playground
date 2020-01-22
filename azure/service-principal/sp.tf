variable "name" {}
variable "sp_client_id" {}
variable "sp_client_secret" {}

resource "azurerm_resource_group" "this" {
  name     = "${var.name}-aks"
  location = "westeurope"
}
 
   service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }
}