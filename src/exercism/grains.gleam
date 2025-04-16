import gleam/int
import gleam/list

pub type Error {
  InvalidSquare
}

pub fn square(square: Int) -> Result(Int, Error) {
  case square {
    x if x > 0 && x < 65 -> Ok(power(2, square - 1, 1))
    _ -> Error(InvalidSquare)
  }
}

pub fn total() -> Int {
  list.range(1, 64) |> list.map(fn(x) { power(2, x - 1, 1) }) |> int.sum
}

fn power(base: Int, exponent: Int, acc: Int) {
  case exponent > 0 {
    True -> power(base, exponent - 1, acc * base)
    False -> acc
  }
}
