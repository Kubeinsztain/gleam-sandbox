import exercism/allergies

pub fn main() {
  let score = 64
  let allergen = allergies.Cats
  allergies.allergic_to(allergen, score) |> echo
}
