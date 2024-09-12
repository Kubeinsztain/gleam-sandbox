import gleam/list
import gleam/string

pub fn is_paired(value: String) -> Bool {
  let brackets_only =
    string.to_graphemes(value) |> list.filter(is_bracket) |> string.join("")

  case brackets_only {
    "" -> True
    _ -> {
      let new_value = remove_pairs(brackets_only)
      case new_value {
        _ if new_value == brackets_only -> False
        _ -> is_paired(new_value)
      }
    }
  }
}

fn is_bracket(char: String) -> Bool {
  char == "("
  || char == ")"
  || char == "["
  || char == "]"
  || char == "{"
  || char == "}"
}

fn remove_pairs(value: String) -> String {
  value
  |> string.replace("()", "")
  |> string.replace("[]", "")
  |> string.replace("{}", "")
}
