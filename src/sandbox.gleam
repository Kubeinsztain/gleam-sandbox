import exercism/list_ops
import gleam/io

pub fn main() {
  io.debug("Reverse")
  list_ops.reverse([1, 2, 3]) |> io.debug
  io.debug("Append")
  list_ops.append([1, 2, 3], [4, 5, 6]) |> io.debug
  io.debug("Concat")
  list_ops.concat([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) |> io.debug
  io.debug("Filter")
  list_ops.filter([1, 2, 3, 4, 5, 6], fn(x) { x % 2 == 0 }) |> io.debug
  io.debug("Length")
  list_ops.length([1, 2, 3, 4, 5, 6]) |> io.debug
  io.debug("Map")
  list_ops.map([1, 2, 3, 4, 5, 6], fn(x) { x * 2 }) |> io.debug
  io.debug("Foldl")
  list_ops.foldl([1, 2, 3, 4, 5, 6], 0, fn(acc, x) {
    io.debug(x)
    acc + x
  })
  |> io.debug
  io.debug("Foldr")
  list_ops.foldr([1, 2, 3, 4, 5, 6], 0, fn(acc, x) {
    io.debug(x)
    acc + x
  })
  |> io.debug
}
