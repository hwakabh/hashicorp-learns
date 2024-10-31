terraform {
  cloud {
    organization = "hwakabh-test"
    # organization = var.tfc_organization_name
    workspaces {
      name = "setup-google-cloud"
      # name = var.tfc_workspace_name
    }
  }
}
