variable "google_cloud_project_id" {
  type = string
  description = "The ID of Google Cloud project where GKE cluster is running"
}

variable "google_cloud_region" {
  type = string
  description = "Google Cloud regions for terraform-provider-google"
}

variable "gke_cluster_name" {
  type        = string
  description = "Name of GKE Cluster created"
  default     = "hwakabh-tf-gke"
}
