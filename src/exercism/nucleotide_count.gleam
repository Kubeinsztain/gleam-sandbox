import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

const valid_nucleotides = ["A", "C", "G", "T"]

pub fn nucleotide_count(dna: String) -> Result(Dict(String, Int), Nil) {
  case is_valid(dna) {
    False -> Error(Nil)
    True -> {
      Ok(count_nucleotides(dna))
    }
  }
}

fn is_valid(nucleotides: String) {
  string.to_graphemes(nucleotides)
  |> list.all(fn(nucleotide) { list.contains(valid_nucleotides, nucleotide) })
}

fn count_nucleotides(dna: String) {
  let base = dict.from_list([#("A", 0), #("C", 0), #("G", 0), #("T", 0)])

  string.to_graphemes(dna)
  |> list.fold(base, fn(acc, nucleotide) {
    dict.upsert(acc, nucleotide, increment)
  })
}

fn increment(x: Option(Int)) {
  case x {
    Some(i) -> i + 1
    None -> 1
  }
}
