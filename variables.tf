### Instance parameters
variable "instances" {
  type = map(object({
    image       = optional(string)
    memory      = optional(number)
    vcpu        = optional(number)
    size        = optional(number)
  }))

  default = {
    vm = {}
  }
}

### Default instance properties
variable "instance_defaults" {
  type = object({
    image       = string
    memory      = number
    vcpu        = number
    size        = number
  })

  default = {
    image     = "ubuntu-22.04-server-cloudimg-amd64.img"
    memory    = 2048
    vcpu      = 2
    size      = 8
  }
}

### Network parameters
variable "network" {
  type = object({
    name    = optional(string)
    pool    = optional(string)
    domain  = optional(string)
  })

  default = {}
}

### User parameters
variable "user" {
  type = object({
    name            = string,
    password        = string,
    ssh_keyname     = optional(string),
    ssh_keybits     = optional(number)
  })

  default = {
    name            = "terraform",
    password        = "terraform",
    ssh_keyname     = "ssh.key",
    ssh_keybits     = 2048
  }
}

### All images for VM's uses
variable "image_urls" {
  type = list
  default = [
    "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
  ]
}

### Output directory
variable "output_dir" {
  type = string
  default = "outputs"
}

### Directory for downloaded images
variable "images_dir" {
  type = string
  default = "images"
}
