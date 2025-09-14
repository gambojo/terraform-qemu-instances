### Create network
resource "libvirt_network" "terraform_net" {
  mode = "nat"

  name = coalesce(
    var.network.name,
    "terraform"
  )

  domain = coalesce(
    var.network.domain,
    "local"
  )

  addresses = [coalesce(
    var.network.pool,
    "192.168.0.0/24"
  )]

  dhcp {
    enabled = true
  }
}
