![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# Getting started on Azure Ampere VMs with OpenSUSE using Terraform

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
* [Using the azure-ampere-vm terraform module](#using-the-azure-ampere-vm-terraform-module)
  * [Configuration with terraform.tfvars](#configuration-with-terraformtfvars)
  * [Creating the main.tf](#creating-the-maintf)
  * [Creating a cloud-init template](#creating-a-cloud-init-template)
  * [Running Terraform](#running-terraform)
  * [Logging in](#logging-in)
  * [Destroying when done](#destroying-done)

## Introduction

[OpenSUSE](https://opensuse.org) is one of the oldest operating systems
based on the Linux kernel originally founded over 29 years ago. Since
its founding, [OpenSUSE](https://opensuse.org) has been developed openly and
distributed freely according to the principles of the GNU Project. The
[OpenSUSE](https://opensuse.org) project is coordinated over the Internet by
a team of volunteers guided by the [OpenSUSE](https://opensuse.org) Project
Leader and three foundational documents: the
[OpenSUSE](https://opensuse.org) Social Contract, the
[OpenSUSE](https://opensuse.org) Constitution, and the
[OpenSUSE](https://opensuse.org) Free Software Guidelines. New
[OpenSUSE](https://opensuse.org) distributions are updated continually, and
the next candidate is released after a time-based freeze.

For those unfamiliar with [OpenSUSE](https://opensuse.org), it has
similarities with other Linux Distrubutions, including similar package
management tooling and methods, packages, and open source software
stacks available for installation easily.

[OpenSUSE](https://opensuse.org) supports the industry standard metadata
interfaces for Linux instance configurations in the cloud,
[Cloud-Init](https://cloud-init.io). This allows you to automate your
[OpenSUSE](https://opensuse.org) workloads. This also means
[OpenSUSE](https://opensuse.org) is perfectly suitable when using on a cloud
platform.

Now personally speaking I have been working with the great team at the
[OpenSUSE](https://opensuse.org) project for some time. For some time now
The [OpenSUSE](https://opensuse.org) Project has used Ampere Platforms to
develop, build and curate packages for each release. I've had the
pleasure of watching their craftmanship, while iterating, and helping
achieve the "it just works" experience for Aarch64 and Ampere platforms
and customers who choose to build and run solutions on
[OpenSUSE](https://opensuse.org). Recently [Microsoft announced the general
availablity of Ampere Altra based processors in
Azure](https://azure.microsoft.com/en-us/blog/azure-virtual-machines-with-ampere-altra-arm-based-processors-generally-available/).
Additionally [OpenSUSE](https://opensuse.org) is one of the available
operating systems for use on Ampere VMs utilizing our cloud-native
Ampere(R) Altra(TM) Aarch64 processors within
[Azure](https://azure.microsoft.com/en-us/).

In this post, we will build upon prevous work to quickly automate using
[OpenSUSE](https://opensuse.org) on Ampere(R) Altra(TM) Arm64 processors
using Ampere VMs within [Azure](https://azure.microsoft.com/en-us/).

## Requirements

To begin you will need a couple things. Personally I'm a big fan of the
the DevOPs tools that support lots of api, and different use cases.
[Terraform](https://www.terraform.io/downloads.html) is one of those
types of tools. If you have seen my previous session from [Microsoft
Build on Cloud Workload
Automation](https://mybuild.microsoft.com/en-US/partners/64d2f9ef-c7dd-43f7-9ee7-85ba25934a06?wt.mc_id=FP_Ampere_blog_Corp#:~:text=cloud%20native%20workload%20automation),
I built a terraform module to quickly get you started using Ampere
platforms on Azure. Today we are going to use that module to launch a
[OpenSUSE](https://opensuse.org) virtual machine while passing in some
metadata to configure it.

-   [Terraform](https://www.terraform.io/downloads.html)
-   [Microsoft Azure Account](https://azure.microsoft.com/en-us/)
-   [Microsoft Azure
    CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

## Using the azure-ampere-vm terraform module

The
[azure-ampere-vm](https://github.com/amperecomputing/terraform-azure-ampere-vm)
terraform module code supplies the minimal amount of information to
quickly have working Ampere A1 instances on Azure ["Always
Free"](https://www.oracle.com/cloud/free/#always-free). It has been
updated to include the ability to easily select
[OpenSUSE](https://opensuse.org) by passing the appropriate parameter during
usage. Additional tasks performed by the
[azure-ampere-vm](https://github.com/amperecomputing/terraform-azure-ampere-vm)
terraform module.

-   Operating system choice abstraction.
-   Dynamically creating sshkeys to use when logging into the instance.
-   Creating necessary core networking configurations for the tenancy
-   Rendering metadata to pass into the Azure Ampere VMs.
-   Launch N number of Azure Ampere VMs with metadata and ssh keys.
-   Output IP information to connect to the instance.

### Configuration with terraform.tfvars

For the purpose of this we will quickly configure Terraform using a
terraform.tfvars in the project directory.\
The following is an example of what terraform.tfvars should look like:

```
    subscription_id = "12345678-abcd-1234-abcd-1234567890ab"
    tenant_id = "87654321-dcba-4321-dcba-ba0987654321"
```

For more information regarding how to get your Azure credentials working
with terraform please refer to the following reading material:

-   [Terraform Azure
    Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
-   [Install the Azure CLI on
    Linux](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)
-   [Install Azure CLI on
    macOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
-   [Install Azure CLI on
    Windows](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows)
-   [Azure CLI authentication in
    Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

### Creating the main.tf

To use the terraform module you must open your favorite text editor and
create a file called main.tf. Copy the following code which allows you
to supply a custom cloud-init template at launch:

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

### Creating a cloud init template.

Using your favorite text editor create a file named cloud-init.yaml.tpl
in the same directory as the main.tf you previously created. Copy the
following content into the text file and save it. With this metadata
file we will add an external 'apt' repository for which will allow us to
install the upstream Docker packages, then we will run a simple
container registry on the OpenSUSE host.

```
#cloud-config

package_update: true
package_upgrade: true

packages:
  - screen
  - rsync
  - git
  - curl
  - docker
  - python3-pip
  - python3-dev
  - python3-selinux
  - python3-setuptools
  - python3-venv
  - libffi-dev
  - gcc
  - libssl-dev

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - systemctl enable docker
  - systemctl start docker
  - docker run -d --name registry --restart=always -p 4000:5000  -v registry:/var/lib/registry registry:2
  - echo 'Azure Ampere VM OpenSUSE Leap Example' >> /etc/motd
```

### Running Terraform

Executing terraform is broken into three commands. The first you must
initialize the terraform project with the modules and necessary plugins
to support proper execution. The following command will do that:

```
terraform init
```

Below is output from a 'terraform init' execution within the project
directory.

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

After 'terraform init' is executed it is necessary to run 'plan' to see
the tasks, steps and objects. that will be created by interacting with
the cloud APIs. Executing the following from a command line will do so:

```
terraform plan
```

The ouput from a 'terraform plan' execution in the project directory
will look similar to the following:

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Finally you will execute the 'apply' phase of the terraform execuction
sequence. This will create all the objects, execute all the tasks and
display any output that is defined. Executing the following command from
the project directory will automatically execute without requiring any
additional interaction:

```
terraform apply -auto-approve
```

The following is an example of output from a 'apply' run of terraform
from within the project directory:

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Logging in

Next you'll need to login with the dynamically generated sshkey that
will be sitting in your project directory. To log in take the ip address
from the output above and run the following ssh command:

```
ssh -i ./azure-id_rsa opensuse@20.69.123.141
```

You should be automatically logged in after running the command. The
following is output from sshing into an instance and then running 'sudo
cat /var/log/messages' to verify cloud-init execution and package
installation:

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Destroying when done

You now should have a fully running and configured OpenSUSE instance. When
finished you will need to execute the 'destroy' command to remove all
created objects in a 'leave no trace' manner. Execute the following from
a command to remove all created objects when finished:

```
terraform destroy -auto-approve
```
The following is example output of the 'terraform destroy' when used on
this project.

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Modifying the cloud-init file and then performing the same workflow will
allow you to get iterating quickly. At this point you should definitely
know how to quickly get automating using OpenSUSE with Ampere on the
Cloud!
