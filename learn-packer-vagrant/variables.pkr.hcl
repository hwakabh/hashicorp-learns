variable "hcp_client_id" {
  type        = string
  description = "client_id of vagrant service-principal for pushing boxes to HCP"
  default     = "${env("HCP_CLIENT_ID")}"
}

variable "hcp_client_secret" {
  type        = string
  description = "client_secret of vagrant service-principal for pushing boxes to HCP"
  default     = "${env("HCP_CLIENT_SECRET")}"
}
