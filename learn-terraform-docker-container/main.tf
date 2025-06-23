// https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

// Pull docker image
resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine-slim"
  keep_locally = false
}

// Run container
resource "docker_container" "nginx-alice" {
  image = docker_image.nginx.image_id
  name  = "nginx-01"

  ports {
    internal = 80
    external = 8081
  }
}

resource "docker_container" "nginx-bob" {
  image = docker_image.nginx.image_id
  name  = "nginx-02"

  ports {
    internal = 80
    external = 8082
  }
}
