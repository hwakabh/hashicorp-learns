terraform {
  required_providers {
    // https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

resource "local_file" "hello" {
  filename = "hello.md"
  content  = var.GREET
}

resource "local_file" "world" {
  filename = "world.md"
  content  = "world, ${var.user_id} from ${var.user_company}"
}
