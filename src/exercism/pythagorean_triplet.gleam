import gleam/int
import gleam/list

pub type Triplet {
  Triplet(Int, Int, Int)
}

pub fn triplets_with_sum(sum: Int) -> List(Triplet) {
  int.range(1, sum / 3 + 1, [], fn(acc, x) {
    int.range(x, sum / 2 + 1, [], fn(acc, y) {
      let z = sum - x - y
      case x * x + y * y == z * z {
        True -> [Triplet(x, y, z), ..acc]
        _ -> acc
      }
    })
    |> list.append(acc, _)
  })
}
