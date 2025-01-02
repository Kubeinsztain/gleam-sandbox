pub type Resistance {
  Resistance(unit: String, value: Int)
}

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  case colors {
    [band_1, band_2, band_3, ..] -> {
      { decode_value(band_1) * 10 + decode_value(band_2) }
      * pow(10, decode_value(band_3))
      |> map_value()
    }
    _ -> Error(Nil)
  }
}

fn decode_value(color: String) -> Int {
  case color {
    "black" -> 0
    "brown" -> 1
    "red" -> 2
    "orange" -> 3
    "yellow" -> 4
    "green" -> 5
    "blue" -> 6
    "violet" -> 7
    "grey" -> 8
    "white" -> 9
    _ -> panic
  }
}

fn map_value(value: Int) -> Result(Resistance, Nil) {
  case value {
    _ if value > 1_000_000_000 ->
      Ok(Resistance("gigaohms", value / 1_000_000_000))
    _ if value > 1_000_000 -> Ok(Resistance("megaohms", value / 1_000_000))
    _ if value > 1000 -> Ok(Resistance("kiloohms", value / 1000))
    _ -> Ok(Resistance("ohms", value))
  }
}

fn pow(base: Int, exponent: Int) -> Int {
  case exponent {
    0 -> 1
    _ -> base * pow(base, exponent - 1)
  }
}
