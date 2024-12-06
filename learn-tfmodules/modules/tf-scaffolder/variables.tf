variable "project_name" {
  type        = string
  description = <<-EOF
    project name for organizing terraform codes.
    value of this variables are used for your directory name created by this module.
  EOF
}

variable "project_storages" {
  type        = list(string)
  description = "GCS Bucket URL for scaffolded projects."

  // validations with each of loop items
  validation {
    condition     = can([for gs in var.project_storages : regex("^gs://", gs)])
    error_message = "Invalid Bucket URL, validate ID with `gcloud storage buckets list`"
  }
}
