### Download all images
resource "null_resource" "download_image" {
  for_each = toset(var.image_urls)

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ${var.images_dir}
      if [ ! -f ${var.images_dir}/${basename(each.value)} ]; then
        curl -skLo ${var.images_dir}/${basename(each.value)} ${each.value}
        echo "The image ${basename(each.value)} was download successful"
      else
        echo "The image ${basename(each.value)} already exists"
      fi
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}

### Create base images
resource "libvirt_volume" "base" {
  for_each = var.instances
  name   = "${each.key}-base"

  source = "${path.module}/${var.images_dir}/${coalesce(
    each.value.image,
    var.instance_defaults.image
  )}"

  format = local.get_format[
    regex("[^.]+$", coalesce(
      each.value.image,
      var.instance_defaults.image
      )
    )
  ]

  depends_on = [ null_resource.download_image ]
}

### Create images for VM's with sizes in Gb
resource "libvirt_volume" "vm_disk" {
  for_each = var.instances
  name   = "${each.key}-volume"
  pool   = "default"
  base_volume_id = libvirt_volume.base[each.key].id
  size   = 1024 * 1024 * 1024 * coalesce(
    each.value.size,
    var.instance_defaults.size
  )

  depends_on = [ libvirt_volume.base ]
}
