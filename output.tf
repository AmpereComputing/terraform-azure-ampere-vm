output "AzureVMPublicIPAddresses" {
  value = "${azurerm_public_ip.pip.*.ip_address}"
}
output "AzureVMSSHPublicKey" {
  value = tls_private_key.azure.public_key_openssh
}
output "AzureVMSSHPrivateKey" {
  sensitive = true
  value     = tls_private_key.azure.private_key_pem
}

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}
