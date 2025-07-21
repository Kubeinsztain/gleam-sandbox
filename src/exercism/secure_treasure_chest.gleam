import gleam/bool
import gleam/string.{length}

// Please define the TreasureChest type
pub opaque type TreasureChest(treasure) {
  TreasureChest(treasure, password: String)
}

pub fn create(
  password: String,
  contents: treasure,
) -> Result(TreasureChest(treasure), String) {
  use <- bool.guard(
    length(password) < 8,
    Error("Password must be at least 8 characters long"),
  )
  Ok(TreasureChest(contents, password))
}

pub fn open(
  chest: TreasureChest(treasure),
  password: String,
) -> Result(treasure, String) {
  let TreasureChest(treasure, chest_pass) = chest
  use <- bool.guard(chest_pass != password, Error("Incorrect password"))
  Ok(treasure)
}
