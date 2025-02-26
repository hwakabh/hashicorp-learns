// enforcement_level should be: hard-mandatory/soft-mandatory/advisory

policy "hello_world_sentinel" {
  source = "./hello.sentinel"
  enforcement_level = "advisory"
}
