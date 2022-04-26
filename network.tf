#Azure Network definition
# Azure Public IP
resource "azurerm_public_ip" "pip" {
  name                         = "${var.rg_prefix}-ip${azure_vm_count.index}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method            = "Dynamic"
  count                        = var.count
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.rg.name
}

# Azure Subnet Definition
resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}subnet${azure_vm_count.index}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = var.subnet_prefix
}

# Azure VM Network Interface
resource "azurerm_network_interface" "nic" {
  # name                = "nic${var.rg_prefix}${azure_vm_count.index}"
  name                = "primaryNic${azure_vm_count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  count               = var.count
  depends_on          = [ azurerm_public_ip.pip ]

  ip_configuration {
    name                          = "ipconfig${var.rg_prefix}${azure_vm_count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${length(azurerm_public_ip.pip.*.id) > 0 ? element(concat(azurerm_public_ip.pip.*.id, list("")), azure_vm_count.index) : ""}" 
  }

  tags {
    environment = "Public Cloud"
  }

}
