resource "random_id" "jsa-tf-eaas-randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.jsa-tf-eaas-rg.name
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "jsa-tf-eaas-storageaccount" {
    name                        = "diag${random_id.jsa-tf-eaas-randomId.hex}"
    resource_group_name         = azurerm_resource_group.jsa-tf-eaas-rg.name
    location                    = "westeurope"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}