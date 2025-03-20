import gleam/int
import gleam/list
import gleam/string

pub fn is_armstrong_number(number: Int) -> Bool {
  let array_of_numbers = to_numbers_array(number)

  sum_of_power_int(array_of_numbers) == number
}

fn sum_of_power_int(numbers) {
  let length = numbers |> list.length
  list.map(numbers, fn(num) { power(num, length) }) |> int.sum
}

fn to_numbers_array(number: Int) {
  number
  |> int.to_string
  |> string.to_graphemes
  |> list.map(fn(element) {
    let assert Ok(num) = int.parse(element)
    num
  })
}

fn power(base: Int, exp: Int) -> Int {
  power_helper(base, exp, 1)
}

fn power_helper(base: Int, exp: Int, acc: Int) -> Int {
  case exp {
    0 -> acc
    _ -> power_helper(base, exp - 1, acc * base)
  }
}
