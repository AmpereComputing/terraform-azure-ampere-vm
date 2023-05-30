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

This can also be used as a terraform module.   The [examples](examples) directory contains example code for module usage showing different operating systems booting with a custom cloud-init templates.   Doing a clone of this repository and changing directory to one of the examples, placing a terraform.tfvars into that directory, and running a typical terrafornm workflow will produce a working virtual machine in the os that was specified in the main.tf that is located within the chosen example directory.

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [local_file.azure-ssh-privkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.azure-ssh-pubkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_uuid.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [tls_private_key.azure](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [template_file.cloud_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created. | `string` | `"10.2.0.0/16"` | no |
| <a name="input_azure_os_image"></a> [azure\_os\_image](#input\_azure\_os\_image) | Default OS Image From the Local Vars | `string` | `"ubuntu2004"` | no |
| <a name="input_azure_vm_count"></a> [azure\_vm\_count](#input\_azure\_vm\_count) | Azure Ampere Virtual machine Config | `number` | `1` | no |
| <a name="input_cloud_init_template_file"></a> [cloud\_init\_template\_file](#input\_cloud\_init\_template\_file) | Optional path for a cloud-init file | `string` | `null` | no |
| <a name="input_instance_prefix"></a> [instance\_prefix](#input\_instance\_prefix) | Name prefix for vm instances | `string` | `"azure-ampere-vm"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | `"westus2"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group in which to create the virtual network. | `string` | `"Terraform-Ampere-on-Azure"` | no |
| <a name="input_rg_prefix"></a> [rg\_prefix](#input\_rg\_prefix) | The shortened abbreviation to represent your resource group that will go on the front of some resources. | `string` | `"rg"` | no |
| <a name="input_subnet_prefix"></a> [subnet\_prefix](#input\_subnet\_prefix) | The address prefix to use for the subnet. | `string` | `"10.2.1.0/24"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Credentials | `string` | `"Azure Subscription ID"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "environment": "Public Cloud"<br>}</pre> | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `string` | `"Azure Tenant ID"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name for the virtual network. | `string` | `"vnet"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Specifies the size of the Azure Ampere virtual machine. | `string` | `"Standard_D16ps_v5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_ampere_vm_private_ipaddresses"></a> [azure\_ampere\_vm\_private\_ipaddresses](#output\_azure\_ampere\_vm\_private\_ipaddresses) | Output the Azure VM(s)) private/internal ip address |
| <a name="output_azure_ampere_vm_public_ipaddresses"></a> [azure\_ampere\_vm\_public\_ipaddresses](#output\_azure\_ampere\_vm\_public\_ipaddresses) | Output the Azure VM(s)) public/external ip address |
| <a name="output_azure_ampere_vm_ssh_private_key"></a> [azure\_ampere\_vm\_ssh\_private\_key](#output\_azure\_ampere\_vm\_ssh\_private\_key) | Output the Azure SSH private key |
| <a name="output_azure_ampere_vm_ssh_public_key"></a> [azure\_ampere\_vm\_ssh\_public\_key](#output\_azure\_ampere\_vm\_ssh\_public\_key) | Output the Azure SSH public key |
| <a name="output_azure_current_subscription_display_name"></a> [azure\_current\_subscription\_display\_name](#output\_azure\_current\_subscription\_display\_name) | Output the Display Name for the current Azure Subscription |
| <a name="output_azure_ssh_private_key"></a> [azure\_ssh\_private\_key](#output\_azure\_ssh\_private\_key) | output the Azure SSH private key |
| <a name="output_azure_ssh_pubic_key"></a> [azure\_ssh\_pubic\_key](#output\_azure\_ssh\_pubic\_key) | output the Azure SSH public key |
| <a name="output_cloud_init"></a> [cloud\_init](#output\_cloud\_init) | Output the rendered cloud-init file |
| <a name="output_random_uuid"></a> [random\_uuid](#output\_random\_uuid) | Output: A randomly generated uuid |
<!-- END_TF_DOCS -->