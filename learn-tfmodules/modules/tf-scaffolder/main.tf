// using 'hashicorp/local' provider
resource "local_file" "readme" {
  filename = "${path.module}/${var.project_name}/README.md"
  content  = "# ${var.project_name}"
}

resource "local_file" "providers" {
  filename = "${path.module}/${var.project_name}/providers.tf"
  content  = <<-EOF
    terraform {
      required_providers {
        local = {
          source = "hashicorp/local"
          version = "2.5.2"
        }
      }
    }
  EOF
}

resource "local_file" "main" {
  filename = "${path.module}/${var.project_name}/main.tf"
  content  = ""
}

resource "local_file" "variables" {
  filename = "${path.module}/${var.project_name}/variables.tf"
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
  source_dir  = "${path.module}/${var.project_name}"
  output_path = "${path.module}/${var.project_name}.tar.gz"
  // note that this archive_file resource and directory created do not assure idempotency in destroy
}
