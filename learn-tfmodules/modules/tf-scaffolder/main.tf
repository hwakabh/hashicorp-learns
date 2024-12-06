// using 'hashicorp/local' provider
resource "local_file" "readme" {
  filename = "${path.root}/${var.project_name}/README.md"
  content  = <<-EOF
      # ${var.project_name}
      ## Project Storage Information
      Type: Google Cloud Storage (GCS)
      Bucket URL:
      - ${var.project_storages[0]}
      - ${var.project_storages[1]}
  EOF
}

resource "local_file" "providers" {
  filename = "${path.root}/${var.project_name}/providers.tf"
  content  = <<-EOF
    terraform {
      required_providers {
        local = {
          source = "hashicorp/google"
          version = "6.12.0"
        }
      }
    }
  EOF
}

resource "local_file" "main" {
  filename = "${path.root}/${var.project_name}/main.tf"
  content  = ""
}

resource "local_file" "variables" {
  filename = "${path.root}/${var.project_name}/variables.tf"
  content  = ""
}


// using 'hashicorp/archive' provider
resource "archive_file" "this" {
  // Need to wait after all file created
  depends_on = [
    local_file.readme,
    local_file.providers,
    local_file.main,
    local_file.variables,
  ]
  type        = "tar.gz"
  source_dir  = "${path.root}/${var.project_name}"
  output_path = "${path.root}/${var.project_name}.tar.gz"
  // note that this archive_file resource and directory created do not assure idempotency in destroy
}
