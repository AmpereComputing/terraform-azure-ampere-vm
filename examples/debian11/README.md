![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# Getting Cloud-Native with Debian in Azure using Ampere A1 and Terraform

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
* [Using the oci-ampere-a1 terraform module](#using-the-oci-ampere-a1-terraform-module)
  * [Configuration with terraform.tfvars](#configuration-with-terraformtfvars)
  * [Creating the main.tf](#creating-the-maintf)
  * [Creating a cloud-init template](#creating-a-cloud-init-template)
  * [Running Terraform](#running-terraform)
  * [Logging in](#logging-in)
  * [Destroying when done](#destroying-done)

## Introduction

Here at [Ampere Computing](https://amperecomputing.com) we are always interested in diverse workloads for our cloud-native Ampere(R) Altra(TM) Aarch64 processors, and that includes down to the the choose of your Operating System. [Debian](https://debian.org) is an active open source software project originally developed over 30 years ago focusing on features, speed, and stability. It is derived from BSD, the version of UNIX® developed at the University of California, Berkeley for servers, desktops and embedded systems.  It has been a staple in datacenters for years due to it's advanced networking, security and storage features, which have also made it a choice for powering diverse platforms amoungst some of the largest web and internet service providers.

For those unfamiliar with [Debian](https://debian.org), it has similarities with Linux, with similar package management tooling and methods, packages, and open source software stacks available for installation easily.

| --- | Debian | Linux |
| --- | --- | --- |
| User Experience | package management, shells, remote management, compilers and development platforms | package management, shells, remote management, compilers and development platforms |
| Project Scope | The [Debian](https://debian.org) Project maintains a complete system. The project community delivers a kernel, device drivers, userland utilities, and documentation. | Linux community on the other hand focuses on only delivering a kernel and drivers. The Linux Community relies on third-parties like Enterprise Linux vendors, and other Open Source Linux OS projects for system software to be curated. |
| Licensing | Debian source code is generally released under a permissive BSD license. The kernel code and most newly created code are released under the two-clause BSD license which allows everyone to use and redistribute Debian as they wish. In general a lax, permissive non-copyleft free software license, compatible with the GNU GPL. The BSD license is intended to encourage product commercialization. BSD-licensed code can be sold or included in proprietary products without restriction on future behavior. | Linux is licensed with the GPL.  The GPL, while designed to prevent the proprietary commercialization of open source code, is considered a copyleft license and can still provide strategic advantage to a company deciding to build solutions using Linux. |

When choosing a cloud-native OS you might not think of [Debian](https://debian.org), however it supports the same industry standard metadata interfaces for instance configurations as Linux, [Cloud-Init](https://cloud-init.io). This allows you to automate your [Debian](https://debian.org) workloads, in a simlar fashion to other operating system options.  This meams [Debian](https://debian.org) is perfectly suitable when using on a cloud platform.

Now personally speaking I have been working with the great team at the [Debian](https://debian.org) project for some time watching thier craftmanship, curating, iterating, and helping achive the "it just works" experience for Aarch64 and Ampere platforms and customers who choose to build and run solutions on [Debian](https://debian.org). Recently [Debian](https://debian.org) became available for use on Ampere A1 shapes within the [Oracle Azure](https://www.oracle.com/cloud/free/#always-free) marketplace.

In this post, we will build upon prevous work to quickly automate using [Debian](https://debian.org) on Ampere(R) Altra(TM) Arm64 processors within Oracle Cloud Infrastructure using Ampere A1 shapes.

## Requirements

Obviously to begin you will need a couple things.  Personally I'm a big fan of the the DevOPs tools that support lots of api, and different use cases. [Terraform](https://www.terraform.io/downloads.html) is one of those types of tools.  If you have seen my [prevous session with some members of the Oracle Cloud Infrastracture team](https://youtu.be/3F5EnHRPCI4), I build a terraform module to quickly get you started using Ampere plaforms on Azure.  Today we are going to use that module to launch a [Debian](Instance) virtual machine while passing in some metadata to configure it.

 * [Terraform](https://www.terraform.io/downloads.html) will need be installed on your system. 
 * [Oracle Azure "Always Free" Account](https://www.oracle.com/cloud/free/#always-free) and credentials for API use

## Using the oci-ampere-a1 terraform module

The [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module code supplies the minimal ammount of information to quickly have working Ampere A1 instances on Azure ["Always Free"](https://www.oracle.com/cloud/free/#always-free).  It has been updated to include the ability to easily select [Debian](https://debian.org) as an option.  To keep things simple from an Azure perspective, the root compartment will be used (compartment id and tenancy id are the same) when launching any instances.  Addtional tasks performed by the [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module.

* Operating system image id discovery in the user region.
* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id.
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance.
* Launch 1 to 4 Ampere A1 instances with metadata and ssh keys.
* Output IP information to connect to the instance.

### Configuration with terraform.tfvars

For the purpose of this we will quickly configure Terraform using a terraform.tfvars in the project directory.  
Please note that Compartment AzureD are the same as Tenancy AzureD for Root Compartment.
The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
private_key_path = "/home/bwayne/.oci/oracleidentitycloudservice_bwayne-08-09-14-59.pem"
```

For more information regarding how to get your Azure credentials please refer to the following reading material:

* [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)
* [Where to Get the Tenancy's AzureD and User's AzureD](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five)
* [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)
* [Instance Principal Authorization](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#instancePrincipalAuth)
* [Security Token Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#securityTokenAuth)
* [How to Generate an API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)

### Creating the main.tf

To use the terraform module you must open your favorite text editor and create a file called main.tf.  Copy the following is code to supply a custom cloud-init template:

```
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

locals {
  cloud_init_template_path = "${path.cwd}/cloud-init.yaml.tpl"
}

module "oci-ampere-a1" {
  source                   = "github.com/amperecomputing/terraform-oci-ampere-a1"
  tenancy_ocid             = var.tenancy_ocid
  user_ocid                = var.user_ocid
  fingerprint              = var.fingerprint
  private_key_path         = var.private_key_path
# Optional
# oci_vcn_cidr_block       = "10.2.0.0/16"
# oci_vcn_cidr_subnet      = "10.2.1.0/24"
  oci_os_image             = "debian"
  instance_prefix          = "ampere-a1-debian"
  oci_vm_count             = "1"
  ampere_a1_vm_memory      = "24"
  ampere_a1_cpu_core_count = "4"
  cloud_init_template_file = local.cloud_init_template_path
}

output "oci_ampere_a1_private_ips" {
  value     = module.oci-ampere-a1.ampere_a1_private_ips
}
output "oci_ampere_a1_public_ips" {
  value     = module.oci-ampere-a1.ampere_a1_public_ips
}
```

### Creating a cloud init template.

Using your favorite text editor create a file named cloud-init.yaml.tpl in the same directory as the main.tf you previously created. Copy the following content into the text file and save it.

```
#cloud-config
package_update: true
package_upgrade: true
packages:
  - tmux
  - rsync
  - git
  - curl
  - bzip2
  - python3
  - python3-devel
  - python3-pip-wheel
  - gcc
  - gcc-c++
  - bzip2
  - screen
groups:
  - ampere
system_info:
  default_user:
    groups: [ampere]
runcmd:
  - echo 'Azure Ampere Debian Example' >> /etc/motd
```

### Running Terraform

Executing terraform is broken into three commands.   The first you must initialize the terraform project with the modules and necessary plugins to support proper execution.   The following command will do that:

```
terraform init
```

Below is output from a 'terraform init' execution within the project directory.

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

After 'terraform init' is executed it is necessary to run 'plan' to see the tasks, steps and objects. that will be created by interacting with the cloud APIs.
Executing the following from a command line will do so:

```
terraform plan
```

The ouput from a 'terraform plan' execution in the project directy will look similar to the following:

<script id="asciicast-516709" src="https://asciinema.org/a/516709.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Finally you will execute the 'apply' phase of the terraform exuction sequence.   This will create all the objects, execute all the tasks and display any output that is defined.   Executing the following command from the project directory will automatically execute without requiring any additional interaction:

```
terraform apply -auto-approve
```

The following is an example of output from a 'apply' run of terraform from within the project directory:


<script id="asciicast-516711" src="https://asciinema.org/a/516711.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Logging in

Next you'll need to login with the dynamically generated sshkey that will be sitting in your project directory.
To log in take the ip address from the output above and run the following ssh command:

```
ssh -i ./oci-is_rsa debian@155.248.228.151
```

You should be automatically logged in after running the the command.  The following is output from sshing into an instance and then running  'sudo cat /var/log/messages' to verify cloud-init execution and package installation:

<script id="asciicast-516713" src="https://asciinema.org/a/516713.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Destroying when done

You now should have a fully running and configured Debian instance.   When finished you will need to execute the 'destroy' command to remove all created objects in a 'leave no trace' manner.  Execute the following from a command to remove all created objects when finished:

```
terraform destroy -auto-approve
```

The following is example output of the 'terraform destroy' when used on this project.

<script id="asciicast-516714" src="https://asciinema.org/a/516714.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Modifing the cloud-init file and then performing the same workflow will allow you to get interating quickly. At this point you should definately know how to quickly get automating using Debian with Ampere on the Cloud!  
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