# Example of running Ubuntu 20.04 on an Azure Ampere Virtual Machine using this module
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "gitlab_access_token" {}

locals {
  cloud_init_template_path = "${path.cwd}/cloud-init.yaml.tpl"
}

module "azure-ampere-vm" {
        source               = "github.com/amperecomputing/terraform-oci-ampere-a1"  
        subscription_id      = var.subscription_id
        tenant_id            = var.tenant_id
     #  Optional
     #  resource_group       = var.resource_group
     #  rg_prefix            = var.rg_prefix
     #  virtual_network_name = var.virtual_network_name
     #  address_space        = var.address_space
     #  subnet_prefix        = var.subnet_prefix
     #  vm_size              = var.vm_size
        location             = "westus2"
        azure_vm_count       = 1
        azure_os_image       = "ubuntu2004"
        instance_prefix      = "azure-ampere-vm-ubuntu-2004"
}
