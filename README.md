![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-azure-ampere-vm

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Terraform code to launch a Ampere virtual machines on Microsoft Azure.

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Microsoft Azure Account](https://azure.microsoft.com/en-us/)
 * [Microsoft Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

## What exactly is Terraform doing

The goal of this code is to supply the minimal ammount of information to quickly have working Ampere virtual machines on ["Azure"](https://azure.microsoft.com/en-us/).
Virtual machines are configured with a simple cloud-config using the Azure metadata provider APIs.

Addtional tasks performed by this code:

* Dynamically creating sshkeys to use when logging into the instance.
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere virtual machine
* Launch Ampere virtual machine with metadata and ssh keys.
* Output IP information to connect to the instance.

To get started clone this repository from GitHub locally.

## Configuration with terraform.tfvars

The easiest way to configure is to use a terraform.tfvars in the project directory.  
The following is an example of what terraform.tfvars should look like:

```
subscription_id = "12345678-abcd-1234-abcd-1234567890ab"
tenant_id = "87654321-dcba-4321-dcba-ba0987654321"
```
### Using as a Module

This can also be used as a terraform module.   The following is example code for module usage supplying a custom cloud-init template:

```
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
        azure_os_image           = "ubuntu2004"
        instance_prefix          = "azure-ampere-vm-ubuntu-2004"
        cloud_init_template_file = local.cloud_init_template_path
}
output "azure_ampere_vm_private_ips" {
  value     = module.azure-ampere-vm.azure_ampere_vm_private_ipaddresses
}
output "azure_ampere_vm_public_ips" {
  value     = module.azure-ampere-vm.azure_ampere_vm_public_ipaddresses
}
```

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```

## References

* [Now in preview Azure virtual machines with ampere altra based processors](https://azure.microsoft.com/en-us/blog/now-in-preview-azure-virtual-machines-with-ampere-altra-armbased-processors)
* [Microsoft Rolls Out Ampere Altra Arm CPUs in Azure](https://www.hpcwire.com/2022/04/05/microsoft-rolls-out-ampere-altra-arm-cpus-in-azure/)
* [Microsoft arms Azure VMs with Ampere Altra chips](https://www.theregister.com/2022/04/05/microsoft_ampere_azure_vm/)
* [Microsoft brings Arm support to Azure virtual machines](https://www.zdnet.com/article/microsoft-brings-arm-support-to-azure-virtual-machines/)
* [Ampere® Altra® Now Available on Microsoft® Azure Cloud Platform](https://amperecomputing.com/blogs/2022-04-04/ampere-altra-now-available-on-microsoft-azure-cloud-platform.html)
* [Microsoft Azure Adds Ampere Altra Arm CPUs](https://www.servethehome.com/microsoft-azure-adds-ampere-altra-arm-cpus/)
* [Microsoft Adds Ampere ARM CPU Support to Azure Virtual Machines](https://petri.com/microsoft-adds-ampere-arm-cpu-support-to-azure-virtual-machines/)
* [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Install the Azure CLI on Linux](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)
* [Install Azure CLI on macOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
* [Install Azure CLI on Windows](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows)
* [Azure CLI authentication in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
* [cloud-init support for virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init)
