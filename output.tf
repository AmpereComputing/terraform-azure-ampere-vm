# =========================================== OUTPUT
output "Azure VM Public IP Addresses: " {
  value = "${azurerm_public_ip.pip.*.ip_address}"
}
output "Azure VM1 DNS Name: " {
  value = "${element(concat(azurerm_dns_a_record.vm_dns.*.name, list(" ")), 0)}.${element(concat(azurerm_dns_a_record.vm_dns.*.zone_name, list(" ")), 0)}"
}
output "Azure VM2 DNS Name: " {
  value = "${element(concat(azurerm_dns_a_record.vm_dns.*.name, list(" ")), 1)}.${element(concat(azurerm_dns_a_record.vm_dns.*.zone_name, list(" ")), 1)}"
}
output "Azure VM SSH Public Key" {
  value = "${tls_private_key.azure_vms.public_key_openssh}"
}
output "Azure VM SSH Private Key" {
  value = "${tls_private_key.azure_vms.private_key_pem}"
}
