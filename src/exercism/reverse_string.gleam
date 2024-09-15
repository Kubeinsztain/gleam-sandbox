import gleam/string

pub fn reverse(value: String) -> String {
  case string.pop_grapheme(value) {
    Ok(#(first, rest)) -> reverse(rest) <> first
    _ -> ""
  }
}
// pub fn reverse(value: String) -> String {
//   string.reverse(value)
// }

// pub fn reverse(value: String) -> String {
//   case value {
//     "" -> ""
//     _ -> {
//       let assert [first, ..rest] = string.to_graphemes(value)
//       reverse(string.join(rest, "")) <> first
//     }
//   }
// }

// import gleam/string.{last, drop_right}
// import gleam/result.{unwrap}

// pub fn reverse(value: String) -> String {
//   case value {
//     "" -> ""
//     _ -> unwrap(last(value), "") <> reverse(drop_right(value, 1))
//   }
// }
