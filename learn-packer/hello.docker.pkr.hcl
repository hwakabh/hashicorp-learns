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
source "docker" "nginx" {
  // define source container images
  image  = "nginx:latest"
  commit = true
}

// build docker image from source predefined above
build {
  name = "hello-packer"
  sources = [
    "source.docker.nginx"
  ]
  provisioner "shell" {
    inline = ["echo \"hello world\""]
  }
  provisioner "shell" {
    inline = ["echo \"hello another world\""]
  }

}

