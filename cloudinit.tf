### Cloud init
data "template_file" "user_data" {
  for_each = var.instances

  template = file("${path.module}/templates/cloud-init.tpl")

  vars = {
    hostname      = each.key
    user_name     = var.user.name
    user_password = data.external.password_hasher.result.hash
    public_key    = tls_private_key.ssh_keypair.public_key_openssh
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = var.instances

  name      = "${each.key}-cloudinit"
  user_data = data.template_file.user_data[each.key].rendered
}
