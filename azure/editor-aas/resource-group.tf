resource "azurerm_resource_group" "jsa-tf-eaas-rg" {
    name = "jsa-tf-eaas-rg"
    location = "westeurope"

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}