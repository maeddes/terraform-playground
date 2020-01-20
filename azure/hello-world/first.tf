provider "azurerm" {
    subscription_id = ${ARM_SUBSCRIPTION_ID}
    tenant_id       = ${ARM_TENANT_ID}
}
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup"
    location = "germanywestcentral"

    tags = {
        environment = "Terraform Demo"
    }
}
data "azurerm_client_config" "current" {}

output "account_id" {
  value = "${data.azurerm_client_config.current.service_principal_application_id}"
}