import exercism/newsletter
import gleam/io
import simplifile

pub fn main() {
  let send_email = fn(email) {
    case email {
      "bushra@example.com" -> {
        let assert Ok(log) = simplifile.read("log.txt")
        log |> io.debug
        Ok(Nil)
      }
      "abdi@example.com" -> {
        let assert Ok(log) = simplifile.read("log.txt")
        log |> io.debug
        Error(Nil)
      }
      "bell@example.com" -> {
        let assert Ok(log) = simplifile.read("log.txt")
        log |> io.debug
        Ok(Nil)
      }
      _ -> panic as "Unexpected email given to send_email function"
    }
  }

  newsletter.send_newsletter("emails.txt", "log.txt", send_email)
}
