packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

variable "github_token" {
  type = string
  description = "Personal Access Token for pushing image to GHCR"
  sensitive = true
  default = env("GHCR_PUSH_PAT")
}

locals {
  // https://github.com/hashicorp/packer/issues/9430#issuecomment-645276351
  calver_tag = formatdate("YYYYMMDD-hhmmss", timestamp())
}

source "docker" "distroless-base" {
  // define source container images
  // `net` package of Go will require glibc, so need to use `base` instead of `static`
  image  = "gcr.io/distroless/base-debian12:debug"
  commit = true
  platform = "linux/amd64"
  run_command = [ "-d", "-i", "-t", "--entrypoint=/busybox/sh", "--", "{{.Image}}" ]
  changes = [
    "EXPOSE 8080",
    "ENTRYPOINT [\"/rainpole\"]"
  ]
}

build {
  name    = "rainpole-app"
  sources = [
    "source.docker.distroless-base"
  ]

  // for running file provisioner
  // https://github.com/hashicorp/packer/issues/11283
  provisioner "shell-local" {
    inline = ["docker exec ${build.ID} ln -s /busybox/sh /bin/sh"]
  }

  // Expected `GOOS=linux GOARCH=amd64 go build -o ./cmd/rainpole` outside packer
  provisioner "file" {
    source = "./cmd/rainpole"
    destination = "/rainpole"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "ghcr.io/hwakabh/rainpole"
      tags       = [local.calver_tag, "main"]
      only       = ["docker.distroless-base"]
    }
    post-processor "docker-push" {
      login = true
      login_server = "ghcr.io"
      login_username = "hwakabh"
      login_password = var.github_token
    }
    // https://developer.hashicorp.com/packer/docs/post-processors/manifest
    post-processor "manifest" {
        output = "manifest.json"
        custom_data = {
            // https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/builder/docker#build-shared-information-variables
            image_tag = local.calver_tag
        }
    }
  }
}
