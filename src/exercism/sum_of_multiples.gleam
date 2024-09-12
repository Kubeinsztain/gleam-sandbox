import gleam/list

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  list.flat_map(factors, fn(x) { find_unique_multiples(number: x, limit: limit) })
  |> list.unique
  |> list.fold(0, fn(x, acc) { x + acc })
}

pub fn find_unique_multiples(number number: Int, limit limit: Int) -> List(Int) {
  list.range(1, limit - 1) |> list.filter(fn(x) { number > 0 && x % number == 0 })
}
