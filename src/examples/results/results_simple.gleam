import gleam/io
import gleam/result

pub fn all_example() {
  // Array of valid results
  io.println("Array of valid results")
  let _ =
    [Ok(2), Ok(3)]
    |> echo
    |> result.all
    |> echo
  io.println("----------------------------------------")
  // Array of valid and error results
  io.println("Array of valid and error results")
  [Ok(2), Error("first error"), Ok(3), Error("second error")]
  |> echo
  |> result.all
  |> echo
}

pub fn flatten_example() {
  let _ = Ok(Ok(1)) |> echo |> result.flatten |> echo
  io.println("----------------------------------------")
  let _ = Ok(Ok(Ok(1))) |> echo |> result.flatten |> echo
  io.println("----------------------------------------")
  let _ = Ok(Error("")) |> echo |> result.flatten |> echo
  io.println("----------------------------------------")
  Error(Nil) |> echo |> result.flatten |> echo
}

pub fn is_error_example() {
  Ok(1) |> echo |> result.is_error |> echo
  io.println("----------------------------------------")
  Error(Nil) |> echo |> result.is_error |> echo
}
