# Instance parameters
variable "instances" {
  type = map(object({
    image       = optional(string)
    memory      = optional(number)
    vcpu        = optional(number)
  }))

  default = {
    vm = {
      image     = "ubuntu-22.04-server-cloudimg-amd64.img"
      memory    = 2048
      vcpu      = 2
    }
  }
}

# Default instance properties
variable "instance_defaults" {
  type = object({
    image       = string
    memory      = number
    vcpu        = number
  })

  default = {
    image     = "ubuntu-22.04-server-cloudimg-amd64.img"
    memory    = 2048
    vcpu      = 2
  }
}

# Network parameters
variable "network" {
  type = object({
    name    = string
    pool    = optional(string)
    domain  = optional(string)
  })

  default = {
    name    = "terraform"
    pool    = "192.168.0.0/24"
    domain  = "local"
  }
}

# User parameters
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

variable "image_urls" {
  type = list
  default = [
    "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
  ]
}

variable "output_dir" {
  type = string
  default = "outputs"
}

variable "images_dir" {
  type = string
  default = "images"
}
