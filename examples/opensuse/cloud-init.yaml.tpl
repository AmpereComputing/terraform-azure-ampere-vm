#cloud-config

package_update: true
package_upgrade: true

packages:
  - screen
  - rsync
  - git
  - curl
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
  - echo 'Azure Ampere VM Ubuntu 20.04 Example' >> /etc/motd
