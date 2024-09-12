import gleam/string

pub fn hey(remark: String) -> String {
  let trimmed = string.trim(remark)
  let is_empty = string.is_empty(trimmed)
  let is_question = string.ends_with(trimmed, "?")
  let is_yelling =
    string.uppercase(trimmed) == trimmed && string.lowercase(trimmed) != trimmed
  case trimmed {
    _ if is_empty -> "Fine. Be that way!"
    _ if is_question && is_yelling -> "Calm down, I know what I'm doing!"
    _ if is_question -> "Sure."
    _ if is_yelling -> "Whoa, chill out!"
    _ -> "Whatever."
  }
}
