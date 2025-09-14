### Create key pair for user
resource "tls_private_key" "ssh_keypair" {
  algorithm = "RSA"
  rsa_bits = coalesce(
    var.user.ssh_keybits,
    2048
  )
}

### Import users private key to local file
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_keypair.private_key_pem
  filename = "${path.module}/${var.output_dir}/${coalesce(
    var.user.ssh_keyname,
    "ssh.key"
  )}"
  file_permission = "0600"
}

### Hashing users password
data "external" "password_hasher" {
  program = ["bash", "${path.module}/templates/pwhasher.sh"]
  query = {
    password = var.user.password
  }
}
