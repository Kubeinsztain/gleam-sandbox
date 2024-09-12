import gleam/list
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let prepared =
    string.replace(phrase, " ", "")
    |> string.replace("-", "")
    |> string.lowercase

  string.to_graphemes(prepared) |> list.unique |> list.length
  == string.length(prepared)
}
