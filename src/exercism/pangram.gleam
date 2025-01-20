import gleam/list
import gleam/regex
import gleam/set
import gleam/string

pub fn is_pangram(sentence: String) -> Bool {
  string.trim(sentence)
  |> string.lowercase
  |> alphabetic_filter
  |> string.to_graphemes
  |> set.from_list
  |> set.size
  == 26
}

fn alphabetic_filter(sentence: String) -> String {
  let options = regex.Options(case_insensitive: True, multi_line: False)
  let assert Ok(re) = regex.compile("[a-z]", with: options)

  string.to_graphemes(sentence)
  |> list.filter(regex.check(re, _))
  |> string.join("")
}
