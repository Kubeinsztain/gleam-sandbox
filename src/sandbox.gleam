import exercism/dna_encoding
import gleam/io

pub fn main() {
  let test_value = <<0b00110001>>

  test_value |> dna_encoding.decode |> io.debug
}
