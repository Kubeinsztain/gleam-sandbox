import gleam/list

// XXX few other ways to solve this problem
// pub fn egg_count(number: Int) -> Int {
//   int.digits(number, 2) |> result.unwrap([]) |> int.sum
// }

// best one in my opinion
// pub fn egg_count(number: Int) -> Int {
//   case number {
//     0 -> 0
//     n -> n % 2 + egg_count(n / 2)
//   }
// }

// pub fn egg_counter(number: Int) {
//   number |> int.to_base2 |> string.replace("0", "") |> string.length
// }

pub fn egg_count(number: Int) -> Int {
  let binary = convert_to_binary(number)
  count_ones(binary)
}

fn convert_to_binary(number: Int) -> List(Int) {
  case number {
    0 -> [0]
    1 -> [1]
    _ -> list.append(convert_to_binary(number / 2), [number % 2])
  }
}

fn count_ones(binary: List(Int)) -> Int {
  list.filter(binary, fn(x) { x == 1 }) |> list.length
}
