// Invoking public modules named with `my_buckets`
module "my_buckets" {
  // https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest
  source  = "terraform-google-modules/cloud-storage/google"
  version = "8.0.1"

  project_id = var.project_id
  // Note that bucket name in Google Cloud should be unique in "global-level",
  // so that we need to randomize for avoiding name conflicts
  prefix           = var.doormat_env
  names            = ["primary", "backup"]
  randomize_suffix = true
}

// Call self-developed modules
module "learn-tf-project" {
  source       = "./modules/tf-scaffolder"
  project_name = "learn-tf"
  // use outputs of modules
  // https://github.com/terraform-google-modules/terraform-google-cloud-storage/blob/master/outputs.tf#L61
  project_storages = module.my_buckets.urls_list
}
