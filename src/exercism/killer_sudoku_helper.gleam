import gleam/list

const collection = [1, 2, 3, 4, 5, 6, 7, 8, 9]

pub fn combinations(
  size size: Int,
  sum sum: Int,
  exclude exclude: List(Int),
) -> List(List(Int)) {
  list.combinations(collection, size)
  |> list.fold([], fn(acc, group) {
    let exclude_group = list.any(group, fn(x) { list.contains(exclude, x) })
    let group_sum = list.fold(group, 0, fn(acc, value) { acc + value })
    case !exclude_group && group_sum == sum {
      True -> [group, ..acc]
      False -> acc
    }
  })
  |> list.reverse()
}
