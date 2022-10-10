# Azure Aarch64 Images
locals {
    os_images = {
      almalinux8 = {
        image_publisher = "almalinux"
        image_offer     = "almalinux-8-arm64"
        image_sku       = "8-arm64"
        image_version   = "latest"
        default_os_user = "almalinux"
      }
      debian11     = {
        image_publisher = "Debian"
        image_offer     = "debian-11-arm64"
        image_sku       = "11-backports"
        image_version   = "latest"
        default_os_user = "debian"
      }
      mariner     = {
        image_publisher = "MicrosoftCBLMariner"
        image_offer     = "cbl-mariner"
        image_sku       = "cbl-mariner-2-arm64"
        image_version   = "latest"
        default_os_user = "mariner"
      }
      opensuse     = {
        image_publisher = "SUSE"
        image_offer     = "opensuse-leap-15-4-arm64"
        image_sku       = "GEN2"
        image_version   = "latest"
        default_os_user = "opensuse"
      }
      ubuntu2204     = {
        image_publisher = "canonical"
        image_offer     = "0001-com-ubuntu-server-jammy"
        image_sku       = "22_04-lts-arm64"
        image_version   = "latest"
        default_os_user = "ubuntu"
      }
      ubuntu2004     = {
        image_publisher = "canonical"
        image_offer     = "0001-com-ubuntu-server-focal"
        image_sku       = "20_04-lts-arm64"
        image_version   = "latest"
        default_os_user = "ubuntu"
      }
      ubuntu1804     = {
        image_publisher = "canonical"
        image_offer     = "UbuntuServer"
        image_sku       = "18_04-daily-lts-arm64"
        image_version   = "latest"
        default_os_user = "ubuntu"
      }
   }

}
