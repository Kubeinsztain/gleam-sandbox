import gleam/option.{Some}
import gleam/regexp.{Match}

pub fn is_valid_line(line: String) -> Bool {
  let assert Ok(re) = regexp.from_string("\\[(DEBUG|INFO|WARNING|ERROR)\\]")
  regexp.check(re, line)
}

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regexp.from_string("<[~|\\*|=|-]*>")
  regexp.split(with: re, content: line)
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(re) = regexp.from_string("User[\\s]+([\\S]+)")
  case regexp.scan(with: re, content: line) {
    [Match(content: _, submatches: [Some(user)])] ->
      "[USER] " <> user <> " " <> line
    _ -> line
  }
}
