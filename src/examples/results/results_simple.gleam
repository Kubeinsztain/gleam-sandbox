import gleam/io
import gleam/result

pub fn all_example() {
  // Array of valid results
  io.println("Array of valid results")
  [Ok(2), Ok(3)]
  |> io.debug
  |> result.all
  |> io.debug
  io.println("----------------------------------------")
  // Array of valid and error results
  io.println("Array of valid and error results")
  [Ok(2), Error("first error"), Ok(3), Error("second error")]
  |> io.debug
  |> result.all
  |> io.debug
}

pub fn flatten_example() {
  Ok(Ok(1)) |> io.debug |> result.flatten |> io.debug
  io.println("----------------------------------------")
  Ok(Ok(Ok(1))) |> io.debug |> result.flatten |> io.debug
  io.println("----------------------------------------")
  Ok(Error("")) |> io.debug |> result.flatten |> io.debug
  io.println("----------------------------------------")
  Error(Nil) |> io.debug |> result.flatten |> io.debug
}

pub fn is_error_example() {
  Ok(1) |> io.debug |> result.is_error |> io.debug
  io.println("----------------------------------------")
  Error(Nil) |> io.debug |> result.is_error |> io.debug
}
