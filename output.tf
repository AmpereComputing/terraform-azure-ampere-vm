# =========================================== OUTPUT
output "AzureVMPublicIPAddresses" {
  value = "${azurerm_public_ip.pip.*.ip_address}"
}
output "AzureVM1DNSName" {
  value = "${element(concat(azurerm_dns_a_record.vm_dns.*.name, list(" ")), 0)}.${element(concat(azurerm_dns_a_record.vm_dns.*.zone_name, list(" ")), 0)}"
}
output "AzureVM2DNSName" {
  value = "${element(concat(azurerm_dns_a_record.vm_dns.*.name, list(" ")), 1)}.${element(concat(azurerm_dns_a_record.vm_dns.*.zone_name, list(" ")), 1)}"
}
output "AzureVMSSHPublicKey" {
  value = "${tls_private_key.azure_vms.public_key_openssh}"
}
output "AzureVMSSHPrivateKey" {
  value = "${tls_private_key.azure_vms.private_key_pem}"
}
