resource "azurerm_virtual_machine" "jsa-tf-eaas-vm" {
    name                  = "jsa-tf-eaas-vm"
    location              = "westeurope"
    resource_group_name   = azurerm_resource_group.jsa-tf-eaas-rg.name
    network_interface_ids = [azurerm_network_interface.jsa-tf-eaas-ni.id]
    vm_size               = "Standard_DS1_v2"
    delete_os_disk_on_termination = true

    storage_os_disk {
        name              = "myOsDisk"
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
        computer_name  = "jsa-tf-eaas-vm"
        admin_username = "testadmin"
        admin_password = "Adminpass123"
    }

    os_profile_linux_config {
        disable_password_authentication = false
        # ssh_keys {
        #     path     = "/home/testadmin/.ssh/authorized_keys"
        #     key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJD5jZouYGRvj6t4mqyN/byut9EC+2FTnLTh4mLvgPX4BTViiUUF50bi/x2TCSQ7qC3cWXV6f0wAeVPZOOKuvUufctEco3IlUz46M8QDC3M7wmHS35tpQsKwl974NGuD+VuiWR0vZjZm2ZD/cQ2Qtg2TmnFOMKgVAS7b61jP9NzwPebG02xKRVorg6RPvIFQ4qcSc4ibbwL6+RcK9s0zEXvhRXAp5cWlInRcs1qbb3o3b2NHh5mZHa9niiq0YucZreiKcUEY8ISHeaLISLjoJf/WfQmDBgR//3JFPyyiYeTMr2lQ1ZDQgIaIkt57rQG6A0ZLmP01h4QTiHtwseIktlokycJhzn9wj19H0g2cBGC7Akvn0HuXxEwVPA6kD/9FYG60nMo94uXI6Rgm4zLGxCSA20HlZdj1cPFdK07pBCfmpbKVGQ51dFNnnvvVQkflSGX53+nj9JvDNcYw3G8l3AQy3vWILZANpmTpGFVcqZsGQxosX19h7TKCS7EtXJpqq3vj2bPlhKpUK35fcZErkW0kRUWrDAnFpxUjIQwFS4+TCVWtMlZc69vDUOxJTXWDqihfsn2//avhEHfKKKhjv6Njgnls1T0OwNtWi0iLVaw0PEzexEVC0SR4q2uMarEoxGqY/SJx9o410qsoHc8CNluhEAdFghzziF0YLX8yKrMQ== julian@julian-ThinkPad-P50"
        # }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.jsa-tf-eaas-storageaccount.primary_blob_endpoint
    }

    connection {
        type = "ssh"
        user = "testadmin"
        password = "Adminpass123"
        # private_key = file("~/Documents/ssh/jsa-tf-eaas.pem")
        host = azurerm_public_ip.jsa-tf-eaas-pubip.ip_address

        timeout = "30s"
    }

    provisioner "file" {
        source = "./remote_scripts/setup.sh"
        destination = "~/setup.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x ~/setup.sh",
            "sudo sh ~/setup.sh"
        ]
    }

    tags = {
        environment = "JSA Terraform EaaS Environment"
    }
}