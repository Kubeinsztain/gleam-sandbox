import exercism/phone_number
import gleam/list
import gleam/result

pub fn main() {
  phone_number.clean("+1 (613)-995-0253")
  phone_number.clean("613-995-0253")
  phone_number.clean("1 613 995 0253")
  phone_number.clean("613.995.0253")
  phone_number.clean("1 (223) 156-7890") |> echo

  list.count(["first", "second"], fn(x) { x == "first" }) |> echo
  result.all([]) |> echo
}
