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
  provisioner "shell" {
    inline = ["echo \"hello world\" >> hello.md"]
  }
  provisioner "shell" {
    inline = ["echo \"hello another world\" >> hello.md"]
  }

  // By default, builder provide no name for image (ref: docker image ls)
  post-processor "docker-tag" {
    repository = "hello-packer"
    tags       = ["latest"]
    only       = ["docker.my-nginx"]
  }

}

