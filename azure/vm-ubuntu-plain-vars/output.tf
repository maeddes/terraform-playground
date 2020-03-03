
output "VM" {
  value = azurerm_virtual_machine.this
}

output "IP" {
  value = azurerm_public_ip.this
}