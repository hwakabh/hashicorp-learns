terraform {
  cloud {
    // could not fetch values from variables.tf
    // https://github.com/hashicorp/terraform/issues/17211#issuecomment-363488498
    organization = "hwakabh"

    workspaces {
      // tfe_workspace_ids will only return the active one, which we can see `terraform workspace list`
      // even if we provided project-wides tags
      tags = ["hwakabh"]
    }
  }

  required_providers {
    // https://registry.terraform.io/providers/hashicorp/tfe/latest/docs
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.59.0"
    }
  }
}
