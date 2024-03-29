# Output the Azure VM(s)) public/external ip address
output "azure_ampere_vm_public_ipaddresses" {
   value = data.azurerm_public_ip.pip.*.ip_address
}

# Output the Azure VM(s)) private/internal ip address
output "azure_ampere_vm_private_ipaddresses" {
  value = azurerm_network_interface.nic.*.private_ip_address
}

# Output the Azure SSH public key
output "azure_ampere_vm_ssh_public_key" {
  value = tls_private_key.azure.public_key_openssh
}

# Output the Azure SSH private key
output "azure_ampere_vm_ssh_private_key" {
  sensitive = true
  value     = tls_private_key.azure.private_key_pem
}

# Output the Display Name for the current Azure Subscription
output "azure_current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}
