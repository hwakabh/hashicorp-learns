// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    workspaces {
      name = var.tfc_workspace_name
    }
  }
}
