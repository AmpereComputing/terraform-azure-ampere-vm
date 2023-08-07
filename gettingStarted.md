# How to get an Azure VM up and running
For more examples and to ask questions, please visit our [developer portal](https://developer.amperecomputing.com) and [developer community](https://community.amperecomputing.com)

This tutorial is designed for you to follow long without really thinking.  I have learned from teaching, writing tutorials, and especially my own learning that the first step is just to get something simple working.  This might be a ‘Hello World’ in software world or a blinking a LED in hardware.  Once you have something running, you will be able to relax and start thinking “what if I change this?” or “what does this do?”  Therefore the goal of this tutorial is to give you a good first taste and hopefully that will inspire you to continue your learnings.

This is based on Ampere Computing's [terraform-azure-ampere-vm](https://github.com/AmpereComputing/terraform-azure-ampere-vm)'s  GitHub Repo. 


## Table of Contents

  * [What we will do:](#what-we-will-do-)
  * [Prerequisites](#prerequisites)
  * [Clone the Terraform Azure Ampere repo](#clone-the-terraform-azure-ampere-repo)
  * [Login to your Azure account](#login-to-your-azure-account)
  * [Create the terraform.tfvars file](#create-the-terraformtfvars-file)
  * [Edit main.tf](#edit-maintf)
  * [Build the instance](#build-the-instance)
  * [ssh into your new VM](#ssh-into-your-new-vm)
  * [Verify in the Azure Portal](#verify-in-the-azure-portal)
  * [Destroy your VM](#destroy-your-vm)
  * [Create Another VM](#create-another-vm)
  * [Notes/Things to try:](#notes-things-to-try-)
  * [What Next?](#what-next-)




## What we will do:
- create an Azure Ubuntu 20.04 instance
- add in some basic tools
  - git, curl, python, docker, ...
- run 'lscpu' to prove that the VM is working
- destroy the instance

When you complete this tutorial, you will have a working Ubuntu 20.04 instance with some common tools.  Since we don’t know what type of account you have (a free account or something from your company) we are just going to create a small 2 core VM instance using Terraform.  The reason to use Terraform is that it automates the creation and destruction and is pretty easy to get started with, but it does have a learn curve for its more advanced features.  Therefore, just follow the directions to get the VM up and running.  Afterwards, you can look through the files and start to understand what TF is doing.  


## Prerequisites
Make sure that you have installed:
 * [Terraform](https://www.terraform.io/downloads.html)
 * [Microsoft Azure Account](https://azure.microsoft.com/en-us/)
 * [Microsoft Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

##  Clone the Terraform Azure Ampere repo
- Open a terminal window and navigate to where you want to place the code and clone this repo

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
## Notes/Things to try:
When you do the destroy command, Terraform goes off and builds everything it needs, it comes back and confirms that you want to destroy it.  I know for me I keep moving on before the prompt pops up.

Create two or more VMs.  In main.tf, there is a variable called azure_vm_count.  This is the number of VMs create.  Change it to 2 and two VMs will be created.

You can change the location by putting in a different region in the location variable.

Naming convention for the instance that we created: Standard_D2ps_v5z The p means ARM and the number (2) is the number of vCPU and p means ARM.  So if you want a 16 vCPUs, change the 2 to 16.  For the other meanings, check out the Azure VM Naming Conventions site. 

## What Next?
Yes, this was a simple example, but if you are new to Terraform, you are realizing how powerful it can be.  To see some more examples, check out the Ampere GitHub page or visit out community at community.ampereComputin.com.
