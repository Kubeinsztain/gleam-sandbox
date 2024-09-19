import gleam/list

pub type Triplet {
  Triplet(Int, Int, Int)
}

pub fn triplets_with_sum(sum: Int) -> List(Triplet) {
  list.range(1, sum / 3)
  |> list.flat_map(fn(x) {
    list.range(x + 1, sum / 2)
    |> list.map(fn(y) {
      let z = sum - x - y
      case x * x + y * y == z * z {
        True -> Triplet(x, y, z)
        _ -> Triplet(0, 0, 0)
      }
    })
  })
  |> list.filter(fn(x) {
    case x {
      Triplet(0, 0, 0) -> False
      _ -> True
    }
  })
}
