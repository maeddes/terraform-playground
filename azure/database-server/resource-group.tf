resource "azurerm_resource_group" "jsa-tf-db-rg" {
    name = "jsa-tf-db-rg"
    location = var.location

    tags = {
        environment = "JSA Terraform Db-Server Environment"
    }
}