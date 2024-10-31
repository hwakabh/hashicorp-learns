// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    # organization = var.tfc_organization_name
    workspaces {
      name = "setup-vault-gke"
      # name = var.tfc_workspace_name
    }
  }
}
