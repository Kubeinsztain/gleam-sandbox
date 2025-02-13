import exercism/rna_transcription
import gleam/io

pub fn main() {
  let dna = "ACGTCGATCGTAG"
  rna_transcription.to_rna(dna) |> io.debug
}
