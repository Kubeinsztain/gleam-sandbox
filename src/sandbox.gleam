import exercism/binary_search_tree
import gleam/io

pub fn main() {
  // let result = "Hello, Gleam!"
  // io.debug(result)
  // io.println(result)

  let tree = binary_search_tree.to_tree([4, 2, 6, 1, 3, 5, 7])
  io.debug(tree)

  // io.debug(binary_search_tree.insert_node(tree, 2))
}
