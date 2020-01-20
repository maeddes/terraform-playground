# Resource Group

resource "azurerm_resource_group" "mhsterraformgroup" {
    name     = "mhsterraformgroup"
    location = "westeurope"

    tags = {
        environment = "Terraform Demo"
    }
}

# Virtual Network

resource "azurerm_virtual_network" "mhsterraformnetwork" {
    name                = "mhsVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.mhsterraformgroup.name

    tags = {
        environment = "Terraform Demo"
    }
}

# Subnet

resource "azurerm_subnet" "mhsterraformsubnet" {
    name                 = "mhsSubnet"
    resource_group_name  = azurerm_resource_group.mhsterraformgroup.name
    virtual_network_name = azurerm_virtual_network.mhsterraformnetwork.name
    address_prefix       = "10.0.2.0/24"
}

# Public IP

resource "azurerm_public_ip" "mhsterraformpublicip" {
    name                         = "mhsPublicIP"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.mhsterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Network Security Group

resource "azurerm_network_security_group" "mhsterraformnsg" {
    name                = "mhsNetworkSecurityGroup"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.mhsterraformgroup.name
    
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
        environment = "Terraform Demo"
    }
}

# NIC

resource "azurerm_network_interface" "mhsterraformnic" {
    name                        = "mhsNIC"
    location                    = "westeurope"
    resource_group_name         = azurerm_resource_group.mhsterraformgroup.name
    network_security_group_id   = azurerm_network_security_group.mhsterraformnsg.id

    ip_configuration {
        name                          = "mhsNicConfiguration"
        subnet_id                     = azurerm_subnet.mhsterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.mhsterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Random Id

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.mhsterraformgroup.name
    }
    
    byte_length = 8
}

# Storage account

resource "azurerm_storage_account" "mhsstorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.mhsterraformgroup.name
    location                    = "westeurope"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}

# VM

resource "azurerm_virtual_machine" "mhsterraformvm" {
    name                  = "mhsVM"
    location              = "westeurope"
    resource_group_name   = azurerm_resource_group.mhsterraformgroup.name
    network_interface_ids = [azurerm_network_interface.mhsterraformnic.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "mhsOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "mhsvm"
        admin_username = "vmadmin"
        admin_password = "passw0rd!"
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
        storage_uri = azurerm_storage_account.mhsstorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}