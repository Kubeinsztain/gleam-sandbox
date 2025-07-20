import exercism/matrix

pub fn main() {
  let valid_input = "9 8 7\n5 3 2\n6 6 7"
  let shady_input = "1 2 3 4\n5 6 7 8\n9 8 7 6"

  echo "Valid Input"
  echo valid_input
  echo "Shady Input"
  echo shady_input

  matrix.row(1, valid_input) |> echo
  matrix.column(1, valid_input) |> echo

  matrix.row(1, shady_input) |> echo
  matrix.column(4, shady_input) |> echo
}
