#resource group definitions
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Azure Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.resource_group}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Public Cloud Nodes"
  }
}

