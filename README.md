![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-azure-ampere-vm

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Terraform code to launch a Ampere virtual machine on Microsoft Azure.

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Microsoft Azure Account](https://azure.microsoft.com/en-us/)



## What exactly is Terraform doing

The goal of this code is to supply the minimal ammount of information to quickly have working Ampere virtual machine on ["Azure"](https://azure.microsoft.com/en-us/).
This instance is confured with metadata to install required software, configure itself.

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
TBD
```

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```

## References

* [Now in preview Azure virtual machines with ampere altra based processors](https://azure.microsoft.com/en-us/blog/now-in-preview-azure-virtual-machines-with-ampere-altra-armbased-processors)
* [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
