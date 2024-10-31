// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = var.tfc_organization_name
    workspaces {
      name = var.tfc_workspace_name
    }
  }
}
