resource "local_file" "hello" {
  filename = "hello.md"
  content  = var.GREET
}

resource "local_file" "world" {
  filename = "world.md"
  content  = "world, ${var.user_id} from ${var.user_company}"
}

// Invoking public modules named with `my_buckets`
module "my_buckets" {
  // https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest
  source = "terraform-google-modules/cloud-storage/google"
  version = "8.0.1"

  project_id = "hc-8b1ddb1733494af2af02d477176"
  names = ["bucket1", "mybucket2"]
  // names needs `prefix` for multiple creation
  prefix = "hw"
}

// use outputs of modules
resource "local_file" "result" {
  // https://github.com/terraform-google-modules/terraform-google-cloud-storage/blob/master/outputs.tf#L61
  content = module.my_buckets.urls_list[1]
  filename = "module_executed_result.md"
}

// Call self-developed modules
