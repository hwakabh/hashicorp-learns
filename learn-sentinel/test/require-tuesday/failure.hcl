mock "time" {
  module {
    source = "./mock-failure.sentinel"
  }
}

// 違反するケースを想定するため、main = false となることをテストする
test {
  rules = {
    main = false
  }
}
