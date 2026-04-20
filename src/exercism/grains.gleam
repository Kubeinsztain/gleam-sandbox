import gleam/int

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
  int.range(1, 65, 0, fn(acc, item) { acc + power(2, item - 1, 1) })
}

fn power(base: Int, exponent: Int, acc: Int) {
  case exponent > 0 {
    True -> power(base, exponent - 1, acc * base)
    False -> acc
  }
}
