import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/regexp.{Options}
import gleam/string

pub fn count_words(input: String) -> Dict(String, Int) {
  replace_non_alphanumeric(input)
  |> trim_quotes
  |> trim_spaces
  |> trim_edge_spaces
  |> string.split(" ")
  |> list.map(string_filters)
  |> list.fold(dict.new(), fn(acc, word) {
    dict.upsert(acc, word, fn(count) {
      case count {
        None -> 1
        Some(c) -> c + 1
      }
    })
  })
}

fn string_filters(value: String) {
  string.lowercase(value)
}

fn replace_non_alphanumeric(value: String) {
  let options = Options(case_insensitive: False, multi_line: True)
  let assert Ok(re) = regexp.compile("[^a-zA-Z0-9' ]", options)

  regexp.replace(re, value, " ")
}

fn trim_quotes(value: String) {
  let options = Options(case_insensitive: False, multi_line: True)
  // trim quotes from the start and end of the string
  let assert Ok(re) =
    regexp.compile("(?<![a-zA-Z0-9])['\"]|['\"](?![a-zA-Z0-9])", options)

  regexp.replace(re, value, " ")
}

fn trim_spaces(value: String) {
  let options = Options(case_insensitive: False, multi_line: True)
  let assert Ok(re) = regexp.compile("[ ]+", options)

  regexp.replace(re, value, " ")
}

fn trim_edge_spaces(value: String) {
  let options = Options(case_insensitive: False, multi_line: True)
  let assert Ok(re) = regexp.compile("(^ +| +$)", options)

  regexp.replace(re, value, "")
}
