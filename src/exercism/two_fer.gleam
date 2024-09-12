import gleam/option.{type Option, None, Some}

pub fn two_fer(name: Option(String)) -> String {
  case name {
    Some(name) -> "One for " <> name <> ", one for me."
    None -> "One for you, one for me."
  }
}
