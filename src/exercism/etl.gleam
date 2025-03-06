import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  legacy
  |> dict.fold([], fn(acc, key, value) {
    value
    |> list.map(fn(val) { #(string.lowercase(val), key) })
    |> list.append(acc)
  })
  |> dict.from_list
}
