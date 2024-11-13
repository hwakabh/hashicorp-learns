packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "zone" {
  type        = string
  default     = "asia-east1-a"
  description = "Zones where artifacts of Packer will be stored"
}

variable "project_id" {
  type        = string
  default     = "hc-8732d2178369440c886cb59aee6"
  description = "Project ID of Google Cloud used by Packer"
}

variable "source_image" {
  type        = string
  default     = "debian-12-bookworm-v20241009"
  description = "Base image listed: gcloud compute image list"
}

variable "source_image_family" {
  type        = string
  default     = "debian-12"
  description = "Iamge family source_image belongs"
}

source "googlecompute" "tmpl" {
  image_name          = "hwakabh-packer-image"
  source_image        = "${var.source_image}"
  source_image_family = "${var.source_image_family}"
  zone                = "${var.zone}"
  project_id          = "${var.project_id}"
  machine_type        = "e2-micro"
  ssh_username        = "packer"
  labels              = { "vendor" : "packer", "dev" : "hwakabh" }
}


build {
  // For HCP Packer Registry
  hcp_packer_registry {
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

  sources = [
    "source.googlecompute.tmpl"
  ]
  provisioner "shell" {
    inline = ["echo \"hello world\""]
  }
  provisioner "shell" {
    inline = ["echo \"hello another world\""]
  }

}

