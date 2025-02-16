import exercism/series
import gleam/io

pub fn main() {
  let input = "918493904243"
  series.slices(input, 5) |> io.debug
}
