output "AzureVMPublicIPAddresses" {
  value = "${azurerm_public_ip.pip.*.ip_address}"
}
output "AzureVMSSHPublicKey" {
  value = "${tls_private_key.azure_vms.public_key_openssh}"
}
output "AzureVMSSHPrivateKey" {
  value = "${tls_private_key.azure_vms.private_key_pem}"
}
