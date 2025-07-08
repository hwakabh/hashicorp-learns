terraform {
  cloud {
    organization = "hwakabh-dev"
    workspaces {
      name = "learn-tfmodules"
    }
  }
  required_providers {
    // https://registry.terraform.io/providers/hashicorp/local/latest/docs
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    // https://registry.terraform.io/providers/hashicorp/google/latest/docs
    google = {
      source  = "hashicorp/google"
      version = "6.12.0"
    }
    // https://registry.terraform.io/providers/hashicorp/null/latest/docs
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

provider "google" {
  region      = "asia-northeast1"
  credentials = pathexpand("~/.config/gcloud/application_default_credentials.json")
}
