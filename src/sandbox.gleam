import exercism/hamming
import gleam/io

pub fn main() {
  let strand1 = "GGACGGATTCTG"
  let strand2 = "AGGACGGATTCT"

  hamming.distance(strand1, strand2) |> io.debug
}
