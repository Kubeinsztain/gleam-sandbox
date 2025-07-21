import exercism/secure_treasure_chest
import gleam/result

pub fn main() {
  let password = "123-456-789"
  use chest <- result.try(secure_treasure_chest.create(password, 49))

  echo secure_treasure_chest.open(chest, password)
  echo secure_treasure_chest.open(chest, "wrong password")
}
