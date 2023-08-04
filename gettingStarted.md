# How to get an Azure VM up and running
For more examples and to ask questions, please visit our [developer portal](https://developer.amperecomputing.com) and [developer community](https://community.amperecomputing.com)

## Table of Contents
  * [What we will do:](#what-we-will-do-)
  * [Prerequisites](#prerequisites)
  * [Clone this repo](#clone-this-repo)
  * [Login to your Azure account](#login-to-your-azure-account)
  * [Create the terraform.tfvars file](#create-the-terraformtfvars-file)
  * [Edit main.tf](#edit-maintf)
  * [Build the instance](#build-the-instance)
  * [ssh into your new VM](#ssh-into-your-new-vm)
  * [Verify in the Azure Portal](#verify-in-the-azure-portal)
  * [Destroy your VM](#destroy-your-vm)
  * [Create Another VM](#create-another-vm)

## What we will do:
- create an Azure Ubuntu 20.04 instance
- add in some basic tools
  - git, curl, python, docker ..
- Look around the instance to prove that it is working
- destroy the instance

This will allow you to create a clean version of the VM over, do your testing, and then destroy the instance so that you won't accidently leave it up and running.  

This tutorial is just going to give you the instructions on how to create the instance, without much explaination of what is happening.  We will add that in later versions at the end of this document. 

## Prerequisites
Make sure that you have installed:
 * [Terraform](https://www.terraform.io/downloads.html)
 * [Microsoft Azure Account](https://azure.microsoft.com/en-us/)
 * [Microsoft Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

##  Clone this repo
- Open a terminal window and navigate to where you want to place the code and clone the repo

```
git clone https://github.com/AmpereComputing/terraform-azure-ampere-vm.git
```

## Login to your Azure account

```
az login
```

A web browser will open up and select the Azure account

The response should look like this:
```
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "3deadd70-fde4-476d-b0de-5739bdc904a7",
    "id": "05dead15-f96b-4f71-315c-b2k2003e0d43",
    "isDefault": true,
    "managedByTenants": [],
    "name": "subscription name",
    "state": "Enabled",
    "tenantId": "3deadd70-fde4-476d-b0de-5739bdc904a7",
    "user":
    {
      "name": "userName@emailaddress.com",
      "type": "user"
    }
  }
]
```
Copy and paste this into your favorite text editor, we will need the id and tenantId in a couple of moments. 

## Create the terraform.tfvars file
- go to the terraform-azure-ampere-vm/examples/ubuntu2004 folder

```
cd terraform-azure-ampere-vm/examples/ubuntu2004
```

- create terraform.tfvars file

```
nano terraform.tfvars
```

In the terraform.tfvars file add in these three variables. 
```
subscription_id = "12345678-abcd-1234-abcd-1234567890ab"
tenant_id = "87654321-dcba-4321-dcba-ba0987654321"
vm_size = "Standard_D2ps_v5"
```
making sure that you change the value for `subscription_id` to that of `id` and `tenant_id` to `tenant_id` that were given to you when you logged in. 

The vm_size is a small 2 core Ampere/ARM64 instance.  Small enough that it will work on a free account.

## Edit main.tf

Open the `main.tf` file that is in the same folder as `terraform.tfvars` file and make sure that there are three variables at the top:
```
variable "subscription_id" {}
variable "tenant_id" {}
variable "vm_size" {}
```

And that in the module block, verify that subscription_id, tenant_id, and vm_size are there and not commented it out. 
```
module "azure-ampere-vm" {
        source              = "github.com/amperecomputing/terraform-azure-ampere-vm"  
        subscription_id     = var.subscription_id
        tenant_id           = var.tenant_id
        vm_size             = var.vm_size
        …
```
## Build the instance

Make sure that everything is saved and run the command:
```
terraform init && terraform plan && terraform apply -auto-approve
```

If you receive a prompt asking you to enter in the subscription_id and/or the tenant_id, check the spelling of the file name: terraform.tfvars and the spelling of subscription_id, tenant_id inside of the file. 

If everything worked correctly, you should see something like this:
```
azure_ampere_vm_private_ips = [
  "10.3.3.4",
]
azure_ampere_vm_public_ips = [
  "13.12.125.272",
]
```
The second one is your public IP address and now just SSH into your new VM.
## ssh into your new VM
```
ssh -i azure-id_rsa ubuntu@13.12.125.272
```

And you should see your Azure Ubuntu prompt.
```
ubuntu@azure-ampere-vm-ubuntu-2004-01:~$
```
type in the command 
```
lscpu
```
Response:
```
ubuntu@azure-ampere-vm-ubuntu-2004-01:~$ lscpu
Architecture:                    aarch64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
CPU(s):                          2
On-line CPU(s) list:             0,1
```
You will see that it is an aarch64 machine, there are 2 CPUs and it is a Neoverse-N1 device.  This means that it is an Ampere Altra or Ampere Altra Max chip.  And if you are like me and you noticed that it is Little Endian, here is the [link](https://en.wikipedia.org/wiki/Endianness) to the Wikipedia article on Endian to remind you what that means. 

## Verify in the Azure Portal
If you now go to your [Azure Portal](https://portal.azure.com/), you will see your VM there.  

## Destroy your VM
And our final move will be to destroy the VM and clean everything up.

Go back to your terminal window.  And type 
```
exit
```
to leave your remote session and get back to your local machine.  Type 
```
terraform destroy
```  

Terraform will come back and verify that you really want to do this. 
```
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```
Type 
```
yes
```

When it is done, everything will be destroyed.  Go to your Azure Portal to verify that the VM is gone and all of the resource groups are gone to.

## Create Another VM
To create another VM, just run the Terraform init command again.
```
terraform init && terraform plan && terraform apply -auto-approve
```
