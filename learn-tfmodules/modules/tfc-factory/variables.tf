variable "org_name" {
  type        = string
  description = "organization name of HCP Terraform to initialize"
  default     = "hwakabh"
}

variable "ORG_TOKEN" {
  type        = string
  description = "token for organization in HCP Terraform, this should be passed via envar"
}

variable "USER_TOKEN" {
  type        = string
  description = "token for user in HCP Terraform, this should be passed via envar"
}
