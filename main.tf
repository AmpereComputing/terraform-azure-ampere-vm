# Cloud Init Metadata
locals {
  # return var.cloud_init_template_path if it's not null
  # otherwise return "${path.module}/templates/cloud-init.yaml.tpl"
  cloud_init_template_file = coalesce(var.cloud_init_template_file, "${path.module}/templates/cloud-init.yaml.tpl")
}

# ssh keys
resource "tls_private_key" "azure" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "azure-ssh-privkey" {
    content = tls_private_key.azure.private_key_pem
    filename = "${path.cwd}/azure-id_rsa"
    file_permission = "0600"
}

resource "local_file" "azure-ssh-pubkey" {
    content  = tls_private_key.azure.public_key_openssh
    filename = "${path.cwd}/azure-id_rsa.pub"
    file_permission = "0644"
}

# output the Azure SSH public key
output "azure_ssh_pubic_key" {
  value = tls_private_key.azure.public_key_openssh
}

# output the Azure SSH private key
output "azure_ssh_private_key" {
  value = tls_private_key.azure.private_key_pem
  sensitive = true
}

resource "random_uuid" "random_id" { }
    
# Output: A randomly generated uuid
output "random_uuid" {
  value = random_uuid.random_id.result 
  sensitive = false
}   

