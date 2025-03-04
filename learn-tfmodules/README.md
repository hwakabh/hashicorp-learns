# learn-tfmodule

## cloud-storage module (simple_bucket + multiple_buckets)
<https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest>


## tf-scaffolder-module
Develop simple modules for file operations
Using `hashicorp/local` provider + `hashicorp/archive` provider, scaffolding Terraform development directory and archive them
<https://registry.terraform.io/providers/hashicorp/local/latest>
<https://registry.terraform.io/providers/hashicorp/archive/latest>

- create several files within single directory
- write some texts to the files created
- control orders in resource creations and archived directories with tarbal


## tfc-factory-module
Also learnings for TFC provider
<https://registry.terraform.io/providers/hashicorp/tfe/latest/docs>

- create projects in organizations
- create workspace
- set environmental/terraform variables in TFC workspace
- create team

```shell
# Passing sensitive values via environmental variables with TF_VAR_*
# case if you use User Token, the user should have permission to manage Org
export TF_TOKEN_app_terraform_io='$your_org_token_or_user_token'
```
