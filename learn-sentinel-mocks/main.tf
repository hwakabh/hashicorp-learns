terraform {
  cloud {
    organization = "hwakabh"
    workspaces {
      name = "mockgen"
    }
  }
}

provider "google" {
  project = "hwakabh-dev"
}

resource "google_storage_bucket" "this" {
  name     = "invalid_name_gcs_bucket"
  location = "US"
}


// playgrounds
provider "tfe" {}

# variable "sensitive_one" {
#   type        = string
#   description = "Test variables for ephemeral"
#   ephemeral   = true
#   default     = "my-project"
# }

resource "tfe_agent_pool" "test-agent-pool" {
  name         = "my-agent-pool-name"
  organization = "hwakabh"
}

ephemeral "tfe_agent_token" "test-agent-token" {
  agent_pool_id = tfe_agent_pool.test-agent-pool.id
  description   = "my-agent-token-name"
}
