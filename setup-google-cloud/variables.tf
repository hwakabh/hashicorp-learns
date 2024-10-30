variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Region resource to be created"
  type        = string
}

variable "zone" {
  description = "Zone resource to be created"
  type        = string
}

variable "gke_username" {
  default     = ""
  description = "Username for GKE nodes"
}

variable "gke_password" {
  default     = ""
  description = "Password for GKE node(s)"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

// For DPC (Dynamic Provider Credentials)
variable "tfc_hostname" {
  type        = string
  description = "The hostname of the TFC or TFE instance you'd like to use with GCP"
}

variable "tfc_project_name" {
  type        = string
  default     = "Default Project"
  description = "The project under which a workspace will be created"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of the workspace that you'd like to create and connect to GCP"
}
