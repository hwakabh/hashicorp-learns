packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}


build {
  sources = [
    "source.googlecompute.gce"
  ]

  hcp_packer_registry {
    bucket_name = "gce-packer"
    description = "First bucket for Packer artifacts"

    bucket_labels = {
      "owner"    = "hwakabh"
      "os"       = "Debian 12"
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }

  provisioner "shell" {
    inline = ["echo \"hello world\" >> hello.md"]
  }
  provisioner "shell" {
    inline = ["echo \"hello another world\" >> hello.md"]
  }

}

