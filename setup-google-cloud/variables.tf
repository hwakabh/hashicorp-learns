variable "google_cloud_project_id" {
  type        = string
  description = "The ID of Google Cloud project where GKE cluster is running"
}

variable "google_cloud_region" {
  type        = string
  description = "Google Cloud regions for terraform-provider-google"
}

variable "google_cloud_zone" {
  type        = string
  description = "Google Cloud regions for terraform-provider-google"
}

variable "gke_num_nodes" {
  type        = number
  description = "Number of gke nodes"
  default     = 1
}

variable "gke_cluster_name" {
  type        = string
  description = "Name of GKE Cluster created"
  default     = "hwakabh-tf-gke"
}

variable "gke_network_prefix" {
  type        = string
  description = "Name of VPC where GKE cluster would be provisioned"
  default     = "hwakabh-gke"
}

variable "gke_subnet_cidr" {
  type        = string
  description = "CIDR of VPC Subnet where each GKE Node would connect"
  default     = "10.10.0.0/24"
}
