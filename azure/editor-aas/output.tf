output "ip_address" {
  value       = azurerm_public_ip.jsa-tf-eaas-pubip.ip_address
  description = "Public IP address for SSH connections"
}