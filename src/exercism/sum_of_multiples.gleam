import gleam/int
import gleam/list

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  list.flat_map(factors, fn(x) {
    find_unique_multiples(number: x, limit: limit)
  })
  |> list.unique
  |> list.fold(0, fn(acc, x) { acc + x })
}

pub fn find_unique_multiples(number number: Int, limit limit: Int) -> List(Int) {
  int.range(limit - 1, 0, [], fn(acc, x) {
    case number > 0 && x % number == 0 {
      True -> [x, ..acc]
      False -> acc
    }
  })
}
