terraform {
  required_providers {
    local = {
      // https://registry.terraform.io/providers/hashicorp/local/latest/docs
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    archive = {
      // https://registry.terraform.io/providers/hashicorp/archive/latest/docs
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}
