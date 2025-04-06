import gleam/int
import gleam/list
import gleam/string

pub fn distance(strand1: String, strand2: String) -> Result(Int, Nil) {
  case string.length(strand1), string.length(strand2) {
    x, y if x == y -> Ok(difference(strand1, strand2))
    _, _ -> Error(Nil)
  }
}

fn difference(strand1: String, strand2: String) -> Int {
  let first = string.to_graphemes(strand1)
  let second = string.to_graphemes(strand2)

  list.map2(first, second, not_equal)
  |> list.fold(0, int.add)
}

fn not_equal(x, y) {
  case x != y {
    False -> 0
    True -> 1
  }
}
