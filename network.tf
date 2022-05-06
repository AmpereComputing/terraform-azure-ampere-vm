#Azure Network definition
# Azure Public IP
resource "azurerm_public_ip" "pip" {
  name                         = "${var.rg_prefix}-ip${count.index}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method            = "Dynamic"
  count                        = var.azure_vm_count
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.rg.name
}

# Azure Subnet Definition
resource "azurerm_subnet" "subnet" {
  #name                 = "${var.rg_prefix}-subnet{count.index}"
  name                 = "${var.rg_prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet_prefix]
}

# Azure VM Network Interface
resource "azurerm_network_interface" "nic" {
  # name                = "nic${var.rg_prefix}${count.index}"
  name                = "primaryNic${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  count               = var.azure_vm_count
  depends_on          = [ azurerm_public_ip.pip ]

  ip_configuration {
    name                          = "ipconfig${var.rg_prefix}${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
#   public_ip_address_id          = "${length(azurerm_public_ip.pip.*.id) > 0 ? element(concat(azurerm_public_ip.pip.*.id, tolist("")), count.index) : ""}"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index)
  }

  tags = {
    environment = "Public Cloud"
  }

}
data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip[count.index].name
  resource_group_name = azurerm_virtual_machine.vm[count.index].resource_group_name
  count               = var.azure_vm_count
}

output "AzureVMPublicIPAddresses" {
  value = data.azurerm_public_ip.pip.*.ip_address
}
