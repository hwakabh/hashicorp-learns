mock "time" {
  module {
    source = "./mock-success.sentinel"
  }
}

// 成功ケースを想定するため、main = true となることをテストする
test {
  rules = {
    main = true
  }
}
