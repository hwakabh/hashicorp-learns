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
