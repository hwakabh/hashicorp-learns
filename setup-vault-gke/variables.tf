variable "tfc_organization_name" {
  type        = string
  default     = "hwakabh-test"
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of the workspace that you'd like to create and connect to GCP"
}

// Need not to pass from environmental variables, since it will be passed from kind: Secret
// Refer default values in "server.enterpriseLicense" field
# variable "vault_ent_license_value" {
#   type        = string
#   description = "Vault Enterprise License string"
# }
