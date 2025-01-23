import exercism/rectangles
import gleam/io

pub fn main() {
  rectangles.rectangles(
  "
  ++
  ++
  ",
)
  |> io.debug
}
