pub type Error {
  NonPositiveNumber
}

pub fn steps(number: Int) -> Result(Int, Error) {
  case number {
    _ if number <= 0 -> Error(NonPositiveNumber)
    _ -> Ok(steps_loop(number, 0))
  }
}

fn steps_loop(number: Int, acc: Int) {
  case number {
    1 -> acc
    _ if number % 2 == 0 -> steps_loop(number / 2, acc + 1)
    _ -> steps_loop(number * 3 + 1, acc + 1)
  }
}
