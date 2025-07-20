import gleam/bool
import gleam/list
import gleam/result
import gleam/string

const numbers_string_array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

const allowed_delimiters = ["-", ".", "(", ")", " "]

const disallowed_punctuations = [":", "!", "@", "#", "$", "%", ";", ","]

pub fn clean(input: String) -> Result(String, String) {
  let input = remove_plus_if_exists(input)
  use _ <- result.try(validate_punctuations(input))
  use _ <- result.try(validate_letters(input))

  let numbers_only = remove_non_numbers(input)

  use <- bool.guard(string.is_empty(numbers_only), Error("no number provided"))

  use _ <- result.try(validate_length(numbers_only))
  use _ <- result.try(validate_area_code(numbers_only))
  use _ <- result.try(validate_exchange_code(numbers_only))

  Ok(trim_first_if_needed(numbers_only))
}

fn remove_plus_if_exists(input: String) -> String {
  case string.starts_with(input, "+") {
    False -> input
    True -> string.drop_start(input, 1)
  }
}

fn remove_non_numbers(input: String) -> String {
  string.to_graphemes(input)
  |> list.filter(fn(x) { list.contains(numbers_string_array, x) })
  |> string.join("")
}

fn validate_length(input: String) -> Result(Nil, String) {
  case string.length(input) {
    10 -> Ok(Nil)
    x if x > 10 -> {
      case x, string.starts_with(input, "1") {
        11, True -> Ok(Nil)
        11, False -> Error("11 digits must start with 1")
        _, _ -> Error("must not be greater than 11 digits")
      }
    }
    x if x < 10 -> Error("must not be fewer than 10 digits")
    _ -> Ok(Nil)
  }
}

fn validate_punctuations(input: String) -> Result(Nil, String) {
  let contains_disallowed_characters = {
    let disallowed_punctuations_count =
      string.to_graphemes(input)
      |> list.filter(fn(x) { list.contains(disallowed_punctuations, x) })
      |> list.length
    disallowed_punctuations_count > 0
  }

  case contains_disallowed_characters {
    True -> Error("punctuations not permitted")
    False -> Ok(Nil)
  }
}

fn validate_letters(input: String) -> Result(Nil, String) {
  let contains_disallowed_characters = {
    let disallowed_letters_count =
      string.to_graphemes(input)
      |> list.filter(fn(x) {
        !list.contains(disallowed_punctuations, x)
        && !list.contains(numbers_string_array, x)
        && !list.contains(allowed_delimiters, x)
      })
      |> list.length
    disallowed_letters_count > 0
  }

  case contains_disallowed_characters {
    True -> Error("letters not permitted")
    False -> Ok(Nil)
  }
}

fn validate_area_code(input: String) -> Result(Nil, String) {
  let drop_amount = {
    case string.length(input) {
      11 -> 1
      _ -> 0
    }
  }

  let assert Ok(area_first_number) =
    string.drop_start(input, drop_amount) |> string.first()

  case area_first_number {
    "0" -> Error("area code cannot start with zero")
    "1" -> Error("area code cannot start with one")
    _ -> Ok(Nil)
  }
}

fn validate_exchange_code(input: String) -> Result(Nil, String) {
  let drop_amount = {
    case string.length(input) {
      11 -> 4
      _ -> 3
    }
  }

  let assert Ok(exchange_first_number) =
    string.drop_start(input, drop_amount) |> string.first()

  case exchange_first_number {
    "0" -> Error("exchange code cannot start with zero")
    "1" -> Error("exchange code cannot start with one")
    _ -> Ok(Nil)
  }
}

fn trim_first_if_needed(input: String) {
  case string.length(input) {
    11 -> string.drop_start(input, 1)
    _ -> input
  }
}
