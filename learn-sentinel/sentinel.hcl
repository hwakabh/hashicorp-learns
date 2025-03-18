// enforcement_level should be: hard-mandatory/soft-mandatory/advisory

// required for using tfplan/v2, tfstate/v2, tfconfig/v2
// https://developer.hashicorp.com/sentinel/docs/features
sentinel {
  features = {
    terraform = true
  }
}

// required for using static imports
// if you mock the data, you will also add this in test/*/*.hcl file as well
import "static" "userdata_imports" {
  source = "./imports/userdata.json"
  format = "json"
}

policy "hello_world_sentinel" {
  source = "./hello.sentinel"
  enforcement_level = "advisory"
}
