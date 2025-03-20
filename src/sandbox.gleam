import exercism/armstrong_numbers
import gleam/io

pub fn main() {
  // let input = 115_132_219_018_763_992_565_095_597_973_971_522_401
  let input = 186_709_961_001_538_790_100_634_132_976_990
  armstrong_numbers.is_armstrong_number(input) |> io.debug
}
