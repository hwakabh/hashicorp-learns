terraform {
  required_providers {
    // https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider google {
  region = "asia-northeast1"
}

resource "local_file" "hello" {
  filename = "hello.md"
  content  = var.GREET
}

resource "local_file" "world" {
  filename = "world.md"
  content  = "world, ${var.user_id} from ${var.user_company}"
}

// Invoking public modules
module "gcs_buckets" {
  // https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest
  source = "terraform-google-modules/cloud-storage/google"
  version = "8.0.1"

  project_id = "hc-8b1ddb1733494af2af02d477176"
  // needs `prefix` for multiple creation
  names = ["bucket1", "mybucket2"]
  prefix = "hw"
}

// Call self-developed modules
