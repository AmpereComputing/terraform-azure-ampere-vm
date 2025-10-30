![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-azure-ampere-vm

[![Source Code](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/AmpereComputing/terraform-azure-ampere-vm)
![documentation workflow](https://github.com/AmpereComputing/terraform-azure-ampere-vm/actions/workflows/documentation.yml/badge.svg?label=build&style=flat-square&branch=main)
[![pages-build-deployment](https://github.com/AmpereComputing/terraform-gcp-ampere-t2a/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/AmpereComputing/terraform-gcp-ampere-t2a/actions/workflows/pages/pages-build-deployment)
[![Latest version](https://img.shields.io/github/tag/AmpereComputing/terraform-azure-ampere-vm.svg?label=release&style=flat&maxAge=3600)](https://github.com/AmpereComputing/terraform-azure-ampere-vm/tags)
[![GitHub issues](https://img.shields.io/github/issues/AmpereComputing/terraform-azure-ampere-vm.svg)](https://github.com/AmpereComputing/terraform-azure-ampere-vm/issues)
![Github stars](https://badgen.net/github/stars/AmpereComputing/terraform-azure-ampere-vm?icon=github&label=stars)
![Github last-commit](https://img.shields.io/github/last-commit/AmpereComputing/terraform-azure-ampere-vm)
[![GitHub forks](https://img.shields.io/github/forks/AmpereComputing/terraform-azure-ampere-vm.svg)](https://github.com/AmpereComputing/terraform-azure-ampere-vm/network)
![Github forks](https://badgen.net/github/forks/AmpereComputing/terraform-azure-ampere-vm?icon=github&label=forks)
![GitHub License](https://img.shields.io/github/license/AmpereComputing/terraform-azure-ampere-vm)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![GitHub deployments](https://img.shields.io/github/deployments/AmpereComputing/terraform-azure-ampere-vm/github-pages)
![Website](https://img.shields.io/website?url=https%3A%2F%2Famperecomputing.github.io/terraform-azure-ampere-vm)

## Description

OpenTofu/Terraform code to launch a Ampere virtual machines on Microsoft Azure.

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Microsoft Azure Account](https://azure.microsoft.com/en-us/)
 * [Microsoft Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

## What exactly is OpenTofu/Terraform doing

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

This can also be used as a OpenTofu or Terraform module.   The [examples](examples) directory contains example code for module usage showing different operating systems booting with a custom cloud-init templates.   Doing a clone of this repository and changing directory to one of the examples, placing a terraform.tfvars into that directory, and running a typical terrafornm workflow will produce a working virtual machine in the os that was specified in the main.tf that is located within the chosen example directory.

### Running using OpenTofu

```
tofu init && tofu plan && tofu apply -auto-approve
```

### Running using Terraform

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
