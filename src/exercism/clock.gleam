import gleam/int

pub type Clock {
  Clock(hour: Int, minute: Int)
}

pub fn create(hour hour: Int, minute minute: Int) -> Clock {
  let time_in_minutes = hour * 60 + minute
  let assert Ok(minutes) = int.modulo(time_in_minutes, 1440)

  let hours = minutes / 60

  Clock(hours, minutes - hours * 60)
}

pub fn add(clock: Clock, minutes minutes: Int) -> Clock {
  create(clock.hour, clock.minute + minutes)
}

pub fn subtract(clock: Clock, minutes minutes: Int) -> Clock {
  create(clock.hour, clock.minute - minutes)
}

pub fn display(clock: Clock) -> String {
  let hours = case clock.hour {
    x if x < 10 -> "0" <> int.to_string(x)
    x -> int.to_string(x)
  }

  let minutes = case clock.minute {
    x if x < 10 -> "0" <> int.to_string(x)
    x -> int.to_string(x)
  }

  hours <> ":" <> minutes
}
