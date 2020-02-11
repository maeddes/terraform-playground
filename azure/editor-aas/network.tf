resource "azurerm_virtual_network" "jsa-tf-eaas-network" {
    name = "jsa-tf-eaas-vnet"
    address_space = ["10.0.0.0/16"]
    location = "westeurope"
    resource_group_name = azurerm_resource_group.jsa-tf-eaas-rg.name

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}

resource "azurerm_subnet" "jsa-tf-eaas-subnet" {
    name                 = "jsa-tf-eaas-subnet"
    resource_group_name  = azurerm_resource_group.jsa-tf-eaas-rg.name
    virtual_network_name = azurerm_virtual_network.jsa-tf-eaas-network.name
    address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "jsa-tf-eaas-pubip" {
    name                         = "jsa-tf-eaas-pubip"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.jsa-tf-eaas-rg.name
    allocation_method            = "Static"

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}

resource "azurerm_network_security_group" "jsa-tf-eaas-nsg" {
    name                = "jsa-tf-eaas-nsg"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.jsa-tf-eaas-rg.name
    
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

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}

resource "azurerm_network_interface" "jsa-tf-eaas-ni" {
    name                        = "jsa-tf-eaas-ni"
    location                    = "westeurope"
    resource_group_name         = azurerm_resource_group.jsa-tf-eaas-rg.name
    network_security_group_id   = azurerm_network_security_group.jsa-tf-eaas-nsg.id

    ip_configuration {
        name                          = "jsa-tf-eaas-ni"
        subnet_id                     = azurerm_subnet.jsa-tf-eaas-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.jsa-tf-eaas-pubip.id
    }

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}