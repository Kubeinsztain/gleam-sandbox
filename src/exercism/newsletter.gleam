import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn read_emails(path: String) -> Result(List(String), Nil) {
  path
  |> simplifile.read
  |> result.map(string.trim)
  |> result.map(string.split(_, "\n"))
  |> result.replace_error(Nil)
}

pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  simplifile.create_file(path) |> result.replace_error(Nil)
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
  simplifile.append(path, email <> "\n") |> result.replace_error(Nil)
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
  use _ <- result.try(create_log_file(log_path))
  use emails <- result.try(read_emails(emails_path))
  {
    use email <- list.map(emails)
    use _ <- result.try(send_email(email))
    use _ <- result.try(log_sent_email(log_path, email))
    Ok(Nil)
  }
  |> list.fold(Ok(Nil), fn(_acc, res) { res })
}
