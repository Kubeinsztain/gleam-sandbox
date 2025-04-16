import exercism/grains
import gleam/io

pub fn main() {
  grains.square(32)
  |> io.debug
}
