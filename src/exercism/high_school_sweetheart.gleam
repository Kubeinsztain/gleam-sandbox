import gleam/list
import gleam/string

pub fn first_letter(name: String) {
  case string.trim(name) |> string.first {
    Ok(letter) -> letter
    Error(_) -> ""
  }
}

pub fn initial(name: String) {
  name |> first_letter |> string.uppercase <> "."
}

pub fn initials(full_name: String) {
  full_name
  |> string.split(" ")
  |> list.map(initial)
  |> string.join(" ")
}

pub fn pair(full_name1: String, full_name2: String) {
  let inits = initials(full_name1) <> "  +  " <> initials(full_name2)
  "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     " <> inits <> "     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
}
