// Stanza ref: <https://developer.hashicorp.com/sentinel/docs/configuration#configuration-file-reference>
// enforcement_level should be: hard-mandatory/soft-mandatory/advisory

// --- static imports
// if you mock the data, you will also add this in test/*/*.hcl file as well
import "static" "allowed_list" {
  source = "./imports/allowed_host_list.json"
  format = "json"
}

// --- plugin imports
// --- --- standard
import "plugin" "time" {
  config = {
    "timezone": "Asia/Tokyo"
  }
}

// --- --- terraform plugins/functions
// required when running `sentinel apply|test` locally
// if using HCP Terraform, the .tfplan files will be on the cloud, no need to add this
import "plugin" "tfplan/v2" {
  config = {
    // generate JSON with `terraform plan -out=terraform.tfplan` and `terraform show -json terraform.tfplan |jq > terraform.tfplan.json`
    // https://developer.hashicorp.com/sentinel/docs/features/terraform/tfplan-v2#configuration-overview
    plan_path = "./imports/terraform.tfplan.json"
  }
}

import "plugin" "tfconfig/v2" {
  config = {
    path = "./imports/terraform.tfplan.json"
  }
}

import "plugin" "tfstate/v2" {
  config = {
    path = "./imports/terraform.tfplan.json"
  }
}

// required for using tfplan/v2, tfstate/v2, tfconfig/v2
// https://developer.hashicorp.com/sentinel/docs/features
sentinel {
  features = {
    terraform = true
  }
}

// --- module imports
import "module" "my_local_module" {
  source = "./imports/my_policies.sentinel"
}


// enable/disable policies
// evaluated with `sentinel` commands without any flags: `sentinel apply`
policy "hello_world_sentinel" {
  source = "./hello.sentinel"
  enforcement_level = "advisory"
}

// override default values in polices (param.sentinel)
param "your_string" {
  value = "override param values sentinel"
}

policy "param" {
  source = "./param.sentinel"
  enforcement_level = "advisory"
  // override the parameter defintions or default values in polices
  params = {
    your_string = "hello, sentinel"
  }
}

policy "hello_sentinel_import" {
  source = "./import.sentinel"
  enforcement_level = "advisory"
}
