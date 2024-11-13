packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "github_pat" {
  type        = string
  description = "PAT for pushing images to ghcr.io"
  default     = "YOUR_GITHUB_PAT"
  # TODO: add notes for gitignored, or enable to accept as stdin
}


// declare to create image for docker
// and source named as nginx
source "docker" "my-nginx" {
  // define source container images
  image  = "nginx:1.27-alpine-slim"
  commit = true
}

// build docker image from source predefined above
build {
  name = "hello-packer"
  sources = [
    "source.docker.my-nginx"
  ]

  // Need to export HCP_CLIENT_ID & HCP_CLIENT_SECRET
  // https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-artifact-metadata
  hcp_packer_registry {
    bucket_name = "docker-nginx"
    description = "artifacts by packer-plugin-docker"
    bucket_labels = {
      "owner" = "hwakabh"
      "type"  = "container-images"
    }
    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }

  // https://developer.hashicorp.com/packer/docs/provisioners/shell
  provisioner "shell" {
    inline = ["echo \"hello world\" >> hello.md"]
  }
  provisioner "shell" {
    inline = ["echo \"hello another world\" >> hello.md"]
  }

  // ref: https://github.com/hashicorp/packer-plugin-docker/issues/151
  // by default, package visibility is `private`
  post-processors {
    // By default, builder provide no name for image (ref: docker image ls)
    // ref: https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag
    post-processor "docker-tag" {
      repository = "ghcr.io/hwakabh/hello-packer"
      tags       = ["latest"]
      only       = ["docker.my-nginx"]
    }

    // Push to GHCR
    // ref: https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-push
    post-processor "docker-push" {
      login          = true
      login_server   = "ghcr.io"
      login_username = "hwakabh"
      login_password = "${var.github_pat}"
    }
  }
}

