// validation with fixed elements
locals {
  env_name = ["dev", "bcp"]
}
variable "doormat_env" {
  type = string
  // length with validation will not work with type=number
  description = "Environments where the resource will be created"
  validation {
    condition     = contains(local.env_name, var.doormat_env)
    error_message = "doormat_env should be ended with `-dev` or `-bcp`."
  }
  validation {
    condition     = length(var.doormat_env) == 3
    error_message = <<-EOF
      "env_name should be 3-characters."
    EOF
  }
}

// envar validation with string pattern
// can be referred with `TF_VAR_GREET` in shell
variable "project_id" {
  type        = string
  description = "ID of Google Cloud's project, where Terraform will create resources."
  # sensitive = true
  validation {
    condition     = can(regex("^hc-", var.project_id))
    error_message = "Invalid projects, validate ID with `gcloud config get project`"
  }
}
