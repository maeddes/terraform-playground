resource "azurerm_virtual_network" "jsa-tf-db-network" {
    name = "jsa-tf-db-vnet"
    address_space = ["10.0.0.0/16"]
    location = "westeurope"
    resource_group_name = azurerm_resource_group.jsa-tf-db-rg.name

    tags = {
        environment = "JSA Terraform Db-Server Environment"
    }
}

resource "azurerm_subnet" "jsa-tf-db-subnet" {
    name                 = "jsa-tf-db-subnet"
    resource_group_name  = azurerm_resource_group.jsa-tf-db-rg.name
    virtual_network_name = azurerm_virtual_network.jsa-tf-db-network.name
    address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "jsa-tf-db-pubip" {
    name                         = "jsa-tf-db-pubip"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.jsa-tf-db-rg.name
    allocation_method            = "Static"

    tags = {
        environment = "JSA Terraform Db-Server Environment"
    }
}

resource "azurerm_network_security_group" "jsa-tf-db-nsg" {
    name                = "jsa-tf-db-nsg"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.jsa-tf-db-rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Webserver"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "JSA Terraform Db-Server Environment"
    }
}

resource "azurerm_network_interface" "jsa-tf-db-ni" {
    name                        = "jsa-tf-db-ni"
    location                    = "westeurope"
    resource_group_name         = azurerm_resource_group.jsa-tf-db-rg.name
    network_security_group_id   = azurerm_network_security_group.jsa-tf-db-nsg.id

    ip_configuration {
        name                          = "jsa-tf-db-ni"
        subnet_id                     = azurerm_subnet.jsa-tf-db-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.jsa-tf-db-pubip.id
    }

    tags = {
        environment = "JSA Terraform Db-Server Environment"
    }
} 