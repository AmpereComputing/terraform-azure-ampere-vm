# Azure Aarch64 Images
locals {
    os_images = {
    # almalinux8 = {
    #   image_publisher = "almalinux"
    #   image_offer     = "0001-com-ubuntu-server-arm-preview-focal"
    #   image_sku       = "20_04-LTS"
    #   image_version   = "latest"
    #   default_os_user = "almalinux"
    # }
      ubuntu2004     = {
        image_publisher = "canonical"
        image_offer     = "0001-com-ubuntu-server-arm-preview-focal"
        image_sku       = "20_04-LTS"
        image_version   = "latest"
        default_os_user = "ubuntu"
      }
      ubuntu1804     = {
        image_publisher = "canonical"
        image_offer     = "0001-com-ubuntu-server-arm-preview-bionic"
        image_sku       = "18_04-LTS"
        image_version   = "latest"
        default_os_user = "ubuntu"
      }
   }

}
