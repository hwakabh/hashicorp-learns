// default value in target policies can be overridden
param "your_string" {
  value = "not sentinel"
}

test {
  rules = {
    main = false
  }
}
