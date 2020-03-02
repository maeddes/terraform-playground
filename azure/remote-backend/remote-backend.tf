terraform {
    backend "azurerm" {
        resource_group_name = "jsa-tf-backends"
        storage_account_name = "terraformbackenddemo"
        container_name = "tfstate"
        key = "dev.remote-backend.demo"
    }
}
