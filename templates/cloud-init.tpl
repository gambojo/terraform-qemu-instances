#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.local
resize_rootfs: true

growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false

packages:
  - curl
  - net-tools
  - sudo
  - qemu-guest-agent
  - openssh-server

users:
  - name: ${user_name}
    passwd: ${user_password}
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    ssh-authorized-keys:
      - '${public_key}'

runcmd:
  - systemctl enable --now qemu-guest-agent
  - systemctl enable --now openssh-server

ssh_pwauth: true
chpasswd:
  expire: false
