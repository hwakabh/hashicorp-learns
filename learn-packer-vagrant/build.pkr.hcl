packer {
  required_plugins {
    vagrant = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vagrant"
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant
    }
  }
}

build {
  sources = [
    "source.vagrant.cloudbox"
  ]

  provisioner "shell" {
    inline = ["echo hello >> hello.md"]
  }

  post-processor "vagrant-registry" {
    box_tag       = "hwakabh/alpine-3-23"
    version       = "1.0.0"
    client_id     = var.hcp_client_id
    client_secret = var.hcp_client_secret
  }
}
