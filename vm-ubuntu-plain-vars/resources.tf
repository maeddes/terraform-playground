variable "name" {}

# Resource Group


resource "azurerm_resource_group" "this" {
  name     = "${var.name}-resource-group"
  location = "westeurope"
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}-virtual-net"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "this" {
  name                 = "${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefix       = "10.10.0.0/20"
  lifecycle {
    ignore_changes = ["route_table_id"]
  }
}

# Public IP

resource "azurerm_public_ip" "this" {
    name                         = "${var.name}-publicIP"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.this.name
    allocation_method            = "Dynamic"

}

# Network Security Group

resource "azurerm_network_security_group" "this" {
    name                = "${var.name}-NetworkSecurityGroup"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.this.name
    
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

}

# NIC

resource "azurerm_network_interface" "this" {
    name                        = "${var.name}-NIC"
    location                    = "westeurope"
    resource_group_name         = azurerm_resource_group.this.name
    network_security_group_id   = azurerm_network_security_group.this.id

    ip_configuration {
        name                          = "${var.name}-NicConfiguration"
        subnet_id                     = azurerm_subnet.this.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.this.id
    }

}

# Random Id

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.this.name
    }
    
    byte_length = 8
}

# Storage account

resource "azurerm_storage_account" "this" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.this.name
    location                    = "westeurope"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

}

# VM

resource "azurerm_virtual_machine" "this" {
    name                  = "${var.name}-VM"
    location              = "westeurope"
    resource_group_name   = azurerm_resource_group.this.name
    network_interface_ids = [azurerm_network_interface.this.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.name}-Disk"
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
        computer_name  = "${var.name}-vm"
        admin_username = "vmadmin"
        admin_password = "passw0rd!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    #    ssh_keys {
    #        path     = "/home/azureuser/.ssh/authorized_keys"
    #        key_data = "ssh-rsa Axxxxh"
    #    }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.this.primary_blob_endpoint
    }

}

