import exercism/word_count
import gleam/io

pub fn main() {
  let test_string = "one,\ntwo,\nthree"

  // let other_string = " multiple   whitespaces"

  word_count.count_words(test_string)
  |> io.debug
}
