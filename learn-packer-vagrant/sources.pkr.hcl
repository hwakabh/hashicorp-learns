// pull box from HCP Vagrant (public) registry and build another
source "vagrant" "cloudbox" {
  source_path  = "bento/debian-11"
  box_version  = "202407.22.0"
  provider     = "vmware_desktop"
  communicator = "ssh"
  output_dir   = "pkr-debian-11"
  skip_package = false // default
  skip_add     = true
}

// fetch box locally and build another
source "vagrant" "localbox" {
  source_path  = "./alpine.base.box"
  provider     = "vmware_desktop"
  communicator = "ssh"
  output_dir   = "./pkr-alpine-3.23"
  skip_package = false // default: false
  skip_add     = true // default: false
  # box_name     = "alpine-base"
}

source "docker" "nginx" {
  image = "bitnami/nginx"
  commit = true
}
