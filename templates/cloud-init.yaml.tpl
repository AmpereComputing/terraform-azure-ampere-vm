#cloud-config

package_update: true
package_upgrade: true

packages:
  - tmux
  - rsync
  - git
  - curl
  - python3
  - python36
  - python36-devel
  - python3-pip-wheel
  - python38
  - python38-devel
  - python38-pip
  - python38-pip-wheel
  - gcc
  - gcc
  - gcc-c++
  - nodejs
  - rust
  - gettext
  - device-mapper-persistent-data
  - lvm2
  - bzip2

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - alternatives --set python /usr/bin/python3.8
  - pip3.8 install -U pip
  - pip3.8 install -U setuptools-rust
  - pip3.8 install -U ansible
  - dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - dnf update -y
  - dnf install docker-ce docker-ce-cli containerd.io -y
  - curl -L https://github.com/docker/compose/releases/download/v${docker_compose_version}/docker-compose-linux-aarch64 -o /usr/local/bin/docker-compose-linux-aarch64
  - chmod -x /usr/local/bin/docker-compose-linux-aarch64
  - ln -s /usr/local/bin/docker-compose-linux-aarch64 /usr/bin/docker-compose
  - docker-compose --version
  - pip3.8 install -U docker-compose
  - docker info
  - systemctl enable docker
  - systemctl start docker
  - cp /home/opc/daemon.json /etc/docker/daemon.json
  - systemctl restart docker
  - docker run -d --name registry --restart=always -p 4000:5000  -v registry:/var/lib/registry registry:2
  - docker info
  - [ bash, /opt/awx_build.sh ]
  - echo 'Azure Ampere Ansible AWX Builder.' >> /etc/motd
