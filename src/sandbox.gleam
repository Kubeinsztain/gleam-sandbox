import exercism/pythagorean_triplet
import gleam/io

pub fn main() {
  pythagorean_triplet.triplets_with_sum(1000) |> io.debug
}
