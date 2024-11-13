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
    // If bucket_name does not exist in HCP Packer Registry, newly created
    bucket_name = "nightly-packer"
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
    inline = ["echo \"hello world\""]
  }
  provisioner "shell" {
    inline = ["echo \"hello another world\""]
  }

}

