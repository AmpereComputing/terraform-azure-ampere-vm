#cloud-config

package_update: false
package_upgrade: false
runcmd:
  - dnf list installed >> ~/MARINER_PACKAGES.txt
  - echo 'Azure Ampere VM CBL-Mariner Example' >> /etc/motd
