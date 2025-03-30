// output of `sentinel apply -trace hello.sentinel`:
// {"day": 31, "hour": 7, "minute": 34, "month": 3, "month_name": "March", "rfc3339": "2025-03-31T07:34:44.446807+09:00", "second": 44, "unix": 1743374084, "unix_nano": 1743374084446807000, "weekday": 1, "weekday_name": "Monday", "year": 2025, "zone": 32400, "zone_string": "+09:00"}
mock "time" {
  data = {
    now = {
      day = 31,
      hour = 7,
      minute = 30,
      month = 3,
      month_name = "March",
    }
  }
}

test {
  rules = {
    main = true
  }
}
