import exercism/clock
import gleam/io

pub fn main() {
  clock.create(hour: 1, minute: -160)
  |> clock.display()
  |> io.debug
}
