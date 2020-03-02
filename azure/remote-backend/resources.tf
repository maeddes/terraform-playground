resource "azurerm_resource_group" "jsa-tf-rb-rg" {
    name = "jsa-tf-rb-rg"
    location = var.location
}

# Virtual Network

resource "azurerm_virtual_network" "jsa-tf-rb-vn" {
    name                = "jsa-tf-rb-vn"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.jsa-tf-rb-rg.name

    tags = {
        environment = "Terraform Azure Backend Demo"
    }
}

# Subnet

resource "azurerm_subnet" "jsa-tf-rb-sn" {
    name                 = "jsa-tf-rb-sn"
    resource_group_name  = azurerm_resource_group.jsa-tf-rb-rg.name
    virtual_network_name = azurerm_virtual_network.jsa-tf-rb-vn.name
    address_prefix       = "10.0.2.0/24"
}

# Public IP

resource "azurerm_public_ip" "jsa-tf-rb-pubip" {
    name                         = "jsa-tf-rb-pubip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.jsa-tf-rb-rg.name
    allocation_method            = "Static"

    tags = {
        environment = "Terraform Azure Backend Demo"
    }
}

# Network Security Group

resource "azurerm_network_security_group" "jsa-tf-rb-sg" {
    name                = "jsa-tf-rb-sg"
    location            = var.location
    resource_group_name = azurerm_resource_group.jsa-tf-rb-rg.name
    
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
        environment = "Terraform Azure Backend Demo"
    }
}

# NIC

resource "azurerm_network_interface" "jsa-tf-rb-ni" {
    name                        = "jsa-tf-rb-ni"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.jsa-tf-rb-rg.name
    network_security_group_id   = azurerm_network_security_group.jsa-tf-rb-sg.id

    ip_configuration {
        name                          = "jsa-tf-rb-ipconfig"
        subnet_id                     = azurerm_subnet.jsa-tf-rb-sn.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.jsa-tf-rb-pubip.id
    }

    tags = {
        environment = "Terraform Azure Backend Demo"
    }
}

# Random Id

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.jsa-tf-rb-rg.name
    }
    
    byte_length = 8
}

# Storage account

resource "azurerm_storage_account" "jsa-tf-rb-sa" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.jsa-tf-rb-rg.name
    location                    = var.location
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "Terraform Azure Backend Demo"
    }
}

# VM

resource "azurerm_virtual_machine" "jsa-tf-rb-vm" {
    name                  = "jsa-tf-rb-vm"
    location              = var.location
    resource_group_name   = azurerm_resource_group.jsa-tf-rb-rg.name
    network_interface_ids = [azurerm_network_interface.jsa-tf-rb-ni.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "jsaOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "jsa-vm"
        admin_username = var.admin_username
        admin_password = var.admin_password
    }

    os_profile_linux_config {
        disable_password_authentication = false
    #    ssh_keys {
    #        path     = "/home/azureuser/.ssh/authorized_keys"
    #        key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
    #    }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.jsa-tf-rb-sa.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Azure Backend Demo"
    }
}
