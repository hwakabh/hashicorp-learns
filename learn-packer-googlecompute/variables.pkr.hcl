variable "gcp_zone" {
  type        = string
  description = "Zones where artifacts of Packer will be stored"
  default     = "asia-east1-a"
}

variable "gcp_project_id" {
  type        = string
  description = "Project ID of Google Cloud used by Packer"
}

variable "gcp_source_image" {
  type        = string
  description = "Base image listed: gcloud compute image list"
  default     = "debian-12-bookworm-v20241009"
}

variable "gcp_source_image_family" {
  type        = string
  description = "Iamge family source_image belongs"
  default     = "debian-12"
}

variable "gcp_machine_type" {
  type = string
  description = "Spec of machine image to build"
}
