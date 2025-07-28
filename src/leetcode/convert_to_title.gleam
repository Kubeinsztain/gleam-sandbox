import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn convert_to_title(column_number: Int) -> String {
  aggregate(column_number, [])
  |> list.map(fn(x) {
    let assert Ok(res) = to_char(x)
    res
  })
  |> string.join("")
}

fn aggregate(number: Int, acc: List(Int)) -> List(Int) {
  case number > 26 {
    True -> {
      let assert Ok(char) = int.modulo(number, 26)
      let rest = number / 26
      aggregate(rest, [char, ..acc])
    }
    False -> [number, ..acc]
  }
}

fn to_char(value: Int) -> Result(String, Nil) {
  case value {
    x if x > 0 && x < 27 -> {
      use converted <- result.try(string.utf_codepoint(x + 64))
      Ok(string.from_utf_codepoints([converted]))
    }
    _ -> Error(Nil)
  }
}
