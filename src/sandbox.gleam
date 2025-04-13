import exercism/satellite
import gleam/io

pub fn main() {
  satellite.tree_from_traversals(inorder: ["i", "a", "f", "x", "r"], preorder: [
    "a", "i", "x", "f", "r",
  ])
  |> io.debug
}
