// Please define the TreasureChest generic custom type
pub type TreasureChest(treasure) {
  TreasureChest(password: String, treasure)
}

// Please define the UnlockResult generic custom type
pub type UnlockResult(treasure) {
  Unlocked(treasure)
  WrongPassword
}

pub fn get_treasure(
  chest: TreasureChest(treasure),
  password: String,
) -> UnlockResult(treasure) {
  case chest {
    TreasureChest(pass, value) if pass == password -> Unlocked(value)
    _ -> WrongPassword
  }
}
