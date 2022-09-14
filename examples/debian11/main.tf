variable "subscription_id" {}
variable "tenant_id" {}

locals {
  cloud_init_template_path = "${path.cwd}/cloud-init.yaml.tpl"
}

module "azure-ampere-vm" {
        source                   = "github.com/amperecomputing/terraform-azure-ampere-vm"  
        subscription_id          = var.subscription_id
        tenant_id                = var.tenant_id
     #  Optional
     #  resource_group           = var.resource_group
     #  rg_prefix                = var.rg_prefix
     #  virtual_network_name     = var.virtual_network_name
     #  address_space            = var.address_space
     #  subnet_prefix            = var.subnet_prefix
     #  vm_size                  = var.vm_size
        location                 = "westus2"
        azure_vm_count           = 1
        azure_os_image           = "debian11"
        instance_prefix          = "azure-ampere-vm-debian-11"
        cloud_init_template_file = local.cloud_init_template_path
}

output "azure_ampere_vm_private_ips" {
  value     = module.azure-ampere-vm.azure_ampere_vm_private_ipaddresses
}
output "azure_ampere_vm_public_ips" {
  value     = module.azure-ampere-vm.azure_ampere_vm_public_ipaddresses
}
