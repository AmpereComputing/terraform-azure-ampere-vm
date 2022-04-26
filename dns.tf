# dns_management resource group definitions
resource "azurerm_resource_group" "dns_management" {
  name     = var.resource_group
  location = var.location
}


# =========================================== DNS 

resource "azurerm_dns_zone" "azure_dns" {
  name                = "az.${domain_name}"
  resource_group_name = azurerm_resource_group.dns_management.name
  zone_type           = "Public"
}

resource "azurerm_dns_cname_record" "gitops-azure_dns" {
  name                = "gitops"
  zone_name           = azurerm_dns_zone.azure_dns.name
  resource_group_name = azurerm_resource_group.dns_management.name
  ttl                 = 300
  record             = "ppouliot.github.io"
}

resource "azurerm_dns_a_record" "vm_dns" {
  count               = "2"
  name                = "${lookup(var.hostname, azure_vm_count.index)}"
  zone_name           = azurerm_dns_zone.azure_dns.name
  resource_group_name = azurerm_resource_group.dns_management.name
  ttl                 = 300
  records             = ["${length(azurerm_public_ip.pip.*.id) > 0 ? element(concat(azurerm_public_ip.pip.*.ip_address, list("")), azure_vm_count.index) : ""}"]
}
