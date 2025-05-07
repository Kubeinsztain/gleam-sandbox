import gleam/list
import gleam/regexp
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
  let options = regexp.Options(case_insensitive: True, multi_line: False)
  let assert Ok(re) = regexp.compile("[a-z]", with: options)

  string.to_graphemes(sentence)
  |> list.filter(regexp.check(re, _))
  |> string.join("")
}
