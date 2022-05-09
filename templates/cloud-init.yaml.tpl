#cloud-config
runcmd:
 - echo 'Azure Ampere VM provisioneds by Terraform.' >> /etc/motd
 - echo 'Find out how here:' >> /etc/motd
 - echo 'https://github.com/AmpereComputing/terraform-azure-ampere-vm' >> /etc/motd

