import gleam/int

pub type Allergen {
  Eggs
  Peanuts
  Shellfish
  Strawberries
  Tomatoes
  Chocolate
  Pollen
  Cats
}

fn allergen_to_int(allergen: Allergen) -> Int {
  case allergen {
    Eggs -> 1
    Peanuts -> 2
    Shellfish -> 4
    Strawberries -> 8
    Tomatoes -> 16
    Chocolate -> 32
    Pollen -> 64
    Cats -> 128
  }
}

fn iteration_to_allergen(value: Int, iteration: Int) -> Result(Allergen, Nil) {
  case value, iteration {
    1, 8 -> Ok(Cats)
    1, 7 -> Ok(Pollen)
    1, 6 -> Ok(Chocolate)
    1, 5 -> Ok(Tomatoes)
    1, 4 -> Ok(Strawberries)
    1, 3 -> Ok(Shellfish)
    1, 2 -> Ok(Peanuts)
    1, 1 -> Ok(Eggs)
    _, _ -> Error(Nil)
  }
}

pub fn allergic_to(allergen: Allergen, score: Int) -> Bool {
  let value = <<score:8>>
  let assert <<value:8>> = value
  let allergen_value = allergen_to_int(allergen)
  int.bitwise_and(allergen_value, value) != 0
}

pub fn list(score: Int) -> List(Allergen) {
  let score = <<score:8>>
  list_acc(score, 8, [])
}

fn list_acc(
  score: BitArray,
  iteration: Int,
  acc: List(Allergen),
) -> List(Allergen) {
  case <<score:bits>> {
    <<allergen_value:1, rest:bits>> -> {
      case iteration_to_allergen(allergen_value, iteration) {
        Ok(allergen) -> list_acc(rest, iteration - 1, [allergen, ..acc])
        Error(_) -> list_acc(rest, iteration - 1, acc)
      }
    }
    _ -> acc
  }
}
