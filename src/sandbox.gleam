import exercism/tournament
import gleam/io

pub fn main() {
//   let test_string =
//     "Allegoric Alaskans;Blithering Badgers;win
// Allegoric Alaskans;Blithering Badgers;win
// Courageous Californians;Allegoric Alaskans;loss"

let typical = "Devastating Donkeys;Blithering Badgers;win
Devastating Donkeys;Blithering Badgers;win
Devastating Donkeys;Blithering Badgers;win
Devastating Donkeys;Blithering Badgers;win
Blithering Badgers;Devastating Donkeys;win"

  // let other_string = ""

  tournament.tally(typical)
  |> io.debug
}
