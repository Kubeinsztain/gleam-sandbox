import gleam/list
import gleam/result

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0
    Cytosine -> 1
    Guanine -> 2
    Thymine -> 3
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0 -> Ok(Adenine)
    1 -> Ok(Cytosine)
    2 -> Ok(Guanine)
    3 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  use acc, value <- list.fold(dna |> list.reverse, <<>>)
  let encoded = encode_nucleotide(value)
  <<encoded:2, acc:bits>>
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  decode_helper(dna, [])
}

fn decode_helper(
  dna: BitArray,
  acc: List(Nucleotide),
) -> Result(List(Nucleotide), Nil) {
  case dna {
    <<>> -> Ok(acc |> list.reverse)
    <<nucleotide:2, rest:bits>> -> {
      use decoded <- result.try(decode_nucleotide(nucleotide))
      decode_helper(rest, [decoded, ..acc])
    }
    _ -> Error(Nil)
  }
}
