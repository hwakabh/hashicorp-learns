// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    workspaces {
      name = "setup-vault-gke"
    }
  }
}
