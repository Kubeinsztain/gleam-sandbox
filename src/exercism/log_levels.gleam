import gleam/string

pub fn message(log_line: String) -> String {
  case log_line {
    "[INFO]:" <> rest -> string.trim(rest)
    "[WARNING]:" <> rest -> string.trim(rest)
    "[ERROR]:" <> rest -> string.trim(rest)
    _ -> ""
  }
}

pub fn log_level(log_line: String) -> String {
  case string.split(log_line, ":") {
    [first, ..] -> {
      string.drop_left(first, 1) |> string.drop_right(1) |> string.lowercase()
    }

    _ -> ""
  }
}

pub fn reformat(log_line: String) -> String {
  let message = message(log_line)
  let level = log_level(log_line)
  message <> " (" <> level <> ")"
}
