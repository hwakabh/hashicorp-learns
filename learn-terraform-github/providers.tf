terraform {
  cloud {
    organization = "hwakabh-dev"
    workspaces {
      name = "learn-terraform-github"
    }
  }
  required_providers {
    // https://registry.terraform.io/providers/integrations/github/latest/docs
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
}

// requires GITHUB_TOKEN
provider "github" {
  owner = "hwakabh"
  token = var.GITHUB_TOKEN
}
