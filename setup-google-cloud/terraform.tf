// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    workspaces {
      name = "setup-google-cloud"
    }
  }
}
