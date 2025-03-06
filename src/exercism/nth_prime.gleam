import gleam/bool

pub fn prime(number: Int) -> Result(Int, Nil) {
  use <- bool.guard(number <= 0, Error(Nil))
  Ok(find_nth_prime(number, 0, 1))
}

pub fn find_nth_prime(number: Int, count: Int, value: Int) -> Int {
  case count == number {
    True -> value - 1
    False -> {
      case is_prime(value, 2) {
        True -> find_nth_prime(number, count + 1, value + 1)
        False -> find_nth_prime(number, count, value + 1)
      }
    }
  }
}

fn is_prime(number: Int, divisor: Int) -> Bool {
  let case_1 = number < 2
  let case_2 = divisor * divisor > number
  let case_3 = number % divisor == 0

  case case_1, case_2, case_3 {
    True, _, _ -> False
    False, True, _ -> True
    False, False, True -> False
    _, _, _ -> is_prime(number, divisor + 1)
  }
}
