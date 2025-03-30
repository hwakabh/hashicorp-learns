mock "time" {
  data = {
    now = {
      day = 31,
      hour = 7,
      minute = 30,
      month = 5,
      month_name = "May",
    }
  }
}

test {
  rules = {
    main = false
  }
}
