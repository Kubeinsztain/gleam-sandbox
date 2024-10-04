import exercism/kindergarten_garden
import gleam/io

pub fn main() {
  kindergarten_garden.plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", kindergarten_garden.Kincaid)
  |> io.debug
}
