resource "libvirt_domain" "vm" {
  for_each = var.instances

  name   = each.key
  memory = coalesce(
    each.value.memory,
    var.instance_defaults.memory
  )

  vcpu   = coalesce(
    each.value.vcpu,
    var.instance_defaults.vcpu
  )

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  network_interface {
    network_id = libvirt_network.terraform_net.id
    wait_for_lease = true
  }

  depends_on = [
    libvirt_network.terraform_net,
    libvirt_volume.vm_disk
  ]
}

output "vm_ips" {
  value = {
    for name, vm in libvirt_domain.vm :
    name => vm.network_interface[0].addresses
  }

  depends_on = [
    libvirt_network.terraform_net,
    libvirt_domain.vm
  ]
}

resource "local_file" "inventory" {
  filename        = "${path.module}/${var.output_dir}/inventory.yml"
  file_permission = "0644"

  content = templatefile("${path.module}/templates/inventory.tpl", {
    timestamp = formatdate("DD-MM-YYYY hh:mm:ss", timestamp())
    username  = var.user.name
    ssh_key   = abspath("${path.module}/${var.output_dir}/ssh.key")
    instances = local.instances_info
  })

  depends_on = [
    libvirt_network.terraform_net,
    libvirt_domain.vm
  ]
}
