data "tfe_organization" "this" {
  name = var.org_name
}


data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = data.tfe_organization.this.name
}

output "console" {
  value = data.tfe_workspace_ids.all
}
