packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
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

  // Some customizations for machine-images
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
      repository = "${var.container_registry_url}/${var.container_registry_username}/hello-packer"
      tags       = ["latest"]
      only       = ["docker.my-nginx"]
    }

    // Push to GHCR
    // ref: https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-push
    post-processor "docker-push" {
      login          = true
      login_server   = var.container_registry_url
      login_username = var.container_registry_username
      login_password = var.container_registry_password
    }
  }
}

