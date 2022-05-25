# Azure Credentials
variable "subscription_id" {
  default     = "Azure Subscription ID"
}
variable "tenant_id" {
  default     = "Azure Tenant ID"
}

# Azure Resource Group and Network Config

variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "Terraform-Ampere-on-Azure"
}

variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "rg"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "westus2"
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.2.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.2.1.0/24"
}

# Azure Ampere Virtual machine Config
variable "azure_vm_count" {
  default = 1
}
variable "azure_os_image" {
  default     = "ubuntu2004"
  description = "Default OS Image From the Local Vars"
}
variable "instance_prefix" {
  description = "Name prefix for vm instances"
  default = "azure-ampere-vm"
}
variable "vm_size" {
  description = "Specifies the size of the Azure Ampere virtual machine."
  default     = "Standard_D16ps_v5"
}

variable "tags" {
  type = map

  default = {
    environment = "Public Cloud"
  }
}
variable "cloud_init_template_file" {
  default     = null
  description = "Optional path for a cloud-init file"
  type        = string
}
