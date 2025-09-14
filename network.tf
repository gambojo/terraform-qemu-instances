resource "libvirt_network" "terraform_net" {
  name = coalesce(
    var.network.name,
    "terraform"
  )
  mode = "nat"
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
