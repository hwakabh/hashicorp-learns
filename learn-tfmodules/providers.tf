terraform {
  required_providers {
    // https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

provider google {
  region = "asia-northeast1"
}
