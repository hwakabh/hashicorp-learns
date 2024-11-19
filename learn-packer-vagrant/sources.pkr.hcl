// pull box from HCP Vagrant (public) registry and build another
source "vagrant" "cloudbox" {
  source_path  = "bento/debian-11"
  box_version  = "202407.22.0"
  provider     = "vmware_desktop"
  communicator = "ssh"
  output_dir   = "pkr-debian-11"
  skip_add     = true
  skip_package = false    // default
}

# // fetch box locally and build another
# source "vagrant" "localbox" {
#   source_path  = "./"
#   communicator = "ssh"
#   output_dir   = "./alpine-3.23"
#   provider     = "vmware_desktop"
#   skip_add     = true
#   skip_package = false    // default
# }
