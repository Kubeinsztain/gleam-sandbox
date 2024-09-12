import gleam/list

pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [day, ..] -> day
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [day, ..rest] -> [day + 1, ..rest]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case days {
    [] -> False
    x -> list.any(x, fn(day) { day == 0 })
  }
}

pub fn total(days: List(Int)) -> Int {
  list.fold(days, 0, fn(acc, day) { day + acc })
}

pub fn busy_days(days: List(Int)) -> Int {
  list.fold(days, 0, fn(acc, day) {
    case day {
      x if x > 4 -> acc + 1
      _ -> acc
    }
  })
}
