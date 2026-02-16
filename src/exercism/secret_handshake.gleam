import gleam/bool
import gleam/int
import gleam/list
import gleam/string

pub type Command {
  Wink
  DoubleBlink
  CloseYourEyes
  Jump
}

pub fn commands(encoded_message: Int) -> List(Command) {
  let binary =
    encoded_message
    |> int.to_base2()
    |> append_zeros

  echo binary

  case string.to_graphemes(binary) {
    [first, ..rest] -> {
      let result = list.index_fold(rest, [], decode_message)

      use <- bool.guard(first == "0", result)
      list.reverse(result)
    }
    _ -> []
  }
}

fn decode_message(acc: List(Command), current: String, index: Int) {
  case index, current {
    0, "1" -> [Jump, ..acc]
    1, "1" -> [CloseYourEyes, ..acc]
    2, "1" -> [DoubleBlink, ..acc]
    3, "1" -> [Wink, ..acc]
    _, _ -> acc
  }
}

fn append_zeros(input: String) {
  case string.length(input) {
    0 -> "00000"
    1 -> "0000" <> input
    2 -> "000" <> input
    3 -> "00" <> input
    4 -> "0" <> input
    _ -> input
  }
}
