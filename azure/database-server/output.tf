output "db-hostname" {
    value = azurerm_mariadb_server.jsa-db-server.fqdn
    description = "Database FQDN"
}

output "ip_address" {
  value       = azurerm_public_ip.jsa-tf-db-pubip.ip_address
  description = "Public IP address of the webserver for SSH connections"
}