import exercism/reverse_string
import gleam/io

pub fn main() {
  "dashboard" |> reverse_string.reverse |> io.println
}
