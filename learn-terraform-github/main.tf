resource "github_repository" "this" {
  name        = "tfsample"
  description = "Sample repository by integrations/github with Terraform"
  visibility  = "private"
  // Note this could not create any branhces in the repo
}

resource "github_repository" "that" {
  name        = "tfsample-init"
  description = "Sample repository by integrations/github with Terraform"
  visibility  = "private"
  auto_init   = true
}
