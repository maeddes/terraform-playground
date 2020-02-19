resource "azurerm_mariadb_server" "jsa-db-server" {
    name                = "mariadb-server"
    location            = var.location
    resource_group_name = "jsa-tf-db-rg"

    sku_name = "B_Gen5_2"

    storage_profile {
        storage_mb            = 51200
        backup_retention_days = 7
        geo_redundant_backup  = "Disabled"
    }

    administrator_login          = "dbadmin"
    administrator_login_password = var.dbadminpassword
    version                      = "10.2"
    ssl_enforcement              = "Enabled"

    depends_on = [azurerm_resource_group.jsa-tf-db-rg]
}

resource "azurerm_mariadb_database" "jsa-example-db" {
    name                = "mariadb_database"
    resource_group_name = "jsa-tf-db-rg"
    server_name         = "mariadb-server"
    charset             = "utf8"
    collation           = "utf8_general_ci"

    depends_on = [azurerm_mariadb_server.jsa-db-server]
}

resource "azurerm_mariadb_firewall_rule" "jsa-db-access" {
    name                = "jsa-ip"
    resource_group_name = "jsa-tf-db-rg"
    server_name         = "mariadb-server"
    start_ip_address    = 
    end_ip_address      = 

    depends_on = [azurerm_mariadb_server.jsa-db-server]
}

resource "azurerm_mariadb_firewall_rule" "webserver-db-access" {
    name                = "webserver-ip"
    resource_group_name = "jsa-tf-db-rg"
    server_name         = "mariadb-server"
    start_ip_address    = azurerm_public_ip.jsa-tf-db-pubip.ip_address
    end_ip_address      = azurerm_public_ip.jsa-tf-db-pubip.ip_address

    depends_on = [azurerm_mariadb_server.jsa-db-server, azurerm_public_ip.jsa-tf-db-pubip]
}