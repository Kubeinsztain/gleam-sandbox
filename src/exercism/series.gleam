import gleam/list
import gleam/string

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  let checks = {
    [
      string.length(input) == 0,
      size < 0,
      size == 0,
      string.length(input) < size,
    ]
  }

  let no_invalid_check = list.all(checks, fn(x) { x == False })

  case no_invalid_check {
    True -> Ok(accumulate(input, size))
    False -> {
      case checks {
        [True, _, _, _] -> Error(EmptySeries)
        [_, True, _, _] -> Error(SliceLengthNegative)
        [_, _, True, _] -> Error(SliceLengthZero)
        [_, _, _, True] -> Error(SliceLengthTooLarge)
        _ -> panic
      }
    }
  }
}

fn accumulate(input: String, size: Int) -> List(String) {
  case string.length(input) >= size {
    True -> {
      let slice = string.slice(input, 0, size)
      list.append([slice], accumulate(string.drop_start(input, 1), size))
    }
    False -> []
  }
}

pub type Error {
  EmptySeries
  SliceLengthNegative
  SliceLengthZero
  SliceLengthTooLarge
}
