packer {
  required_plugins {
    vagrant = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/vagrant"
      // https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant
    }
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

build {
  sources = [
    # "source.vagrant.cloudbox",
    # "source.vagrant.localbox",
    "source.docker.nginx",
  ]

  provisioner "shell" {
    inline = ["echo hello > hello.md"]
  }

  # // ref: https://github.com/hashicorp/packer/issues/5833#issuecomment-362370957
  # post-processor "shell-local" {
  #   inline = ["echo '{\"name\":\"hwakabh/alpine\",\"versions\":[{\"version\":\"1.0.0\",\"providers\":[{\"name\":\"vmware_desktop\",\"url\":\"./package.box\"}]}]}' >> ./pkr-alpine-3.23/metadata.json"]
  # }

  post-processors {
    # // Required if push artifacts of source.docker.nginx
    # // will create packer_nginx_docker_arm64.box (arch: arm64, provider: docker)
    post-processor "vagrant" {}

    post-processor "vagrant-registry" {
      box_tag       = "hwakabh/nginx"
      version       = "1.0.0"
      client_id     = "${var.hcp_client_id}"
      client_secret = "${var.hcp_client_secret}"
    }
  }
}
