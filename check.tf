### Check functions
locals {
  ### dinamic check format of images
  get_format = { 
    "qcow2" = "qcow2"
    "img"   = "qcow2"
    "raw"   = "raw"
  }

  ### get ip's from vm's for output
  instances_info = {
    for name, vm in libvirt_domain.vm :
    name => {
      internal_ip = try(vm.network_interface[0].addresses[0], "unknown")
    }
  }
}

### Check instances for ready
resource "null_resource" "wait_for_vm" {
  for_each = var.instances

  provisioner "local-exec" {
    command = <<EOT
      until virsh domstate ${each.key} | grep -q "running"; do
        echo "Wait for VM..."
        sleep 5
      done
      echo "VM is running!"
    EOT
  }
}
