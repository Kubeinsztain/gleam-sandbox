import exercism/darts
import gleam/io

pub fn main() {
  darts.score(0.0, 0.0) |> io.debug
}
