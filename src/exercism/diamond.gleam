import gleam/list
import gleam/string

pub fn build(letter: String) -> String {
  case string.contains(alphabet, string.uppercase(letter)) {
    True -> {
      string.split(alphabet, letter)
      |> list.first
      |> fn(x) {
        case x {
          Ok(x) -> build_diamond(x <> string.uppercase(letter))
          _ -> ""
        }
      }
    }
    False -> ""
  }
}

const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

pub fn build_diamond(letters: String) -> String {
  let length = string.length(letters)

  let last_index = length - 1

  { letters <> { string.drop_right(letters, 1) |> string.reverse } }
  |> string.to_graphemes
  |> list.index_map(fn(x, i) {
    case i {
      _ if i == 0 -> {
        let padding = string.repeat(" ", length - 1)
        padding <> x <> padding
      }
      _ if i == 2 * last_index -> {
        let padding = string.repeat(" ", length - 1)
        padding <> x <> padding <> "\n"
      }
      _ if i < last_index -> {
        let padding = string.repeat(" ", last_index - i)
        let inner_padding = string.repeat(" ", i * 2 - 1)
        padding <> x <> inner_padding <> x <> padding <> "\n"
      }
      _ if i == last_index -> {
        let padding = string.repeat(" ", last_index * 2 - 1)
        x <> padding <> x <> "\n"
      }
      _ if i > last_index -> {
        let mirror_i = 2 * last_index - i
        let padding = string.repeat(" ", i - last_index)
        let inner_padding = string.repeat(" ", mirror_i * 2 - 1)
        padding <> x <> inner_padding <> x <> padding <> "\n"
      }
      _ -> ""
    }
  })
  |> list.fold("", fn(x, acc) { acc <> x })
}
