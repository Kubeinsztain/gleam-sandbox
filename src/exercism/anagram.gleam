import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  list.filter(candidates, fn(candidate) {
    string.lowercase(word) != string.lowercase(candidate)
    && normalize(word) == normalize(candidate)
  })
}

fn normalize(word: String) -> String {
  string.lowercase(word)
  |> string.to_graphemes
  |> list.sort(by: string.compare)
  |> string.concat
}
