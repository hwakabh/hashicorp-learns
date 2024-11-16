source "googlecompute" "gce" {
  image_name          = "hwakabh-packer-image"
  source_image_family = var.gcp_source_image_family
  zone                = var.gcp_zone
  project_id          = var.gcp_project_id
  machine_type        = var.gcp_machine_type
  ssh_username        = "packer"
  labels              = {
    "vendor" : "packer",
    "dev" : "hwakabh"
  }
}
