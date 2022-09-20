#cloud-config

package_update: true
package_upgrade: true
packages:
  - screen
  - rsync
  - git
  - curl

runcmd:
  - echo 'Azure Ampere VM Debian 11 Example' >> /etc/motd
