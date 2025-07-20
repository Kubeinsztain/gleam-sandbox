import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn row(index: Int, string: String) -> Result(List(Int), Nil) {
  use rows <- result.try(to_list_of_rows(string))
  list.drop(rows, index - 1) |> list.first()
}

pub fn column(index: Int, string: String) -> Result(List(Int), Nil) {
  use rows <- result.try(to_list_of_rows(string))
  use cols <- result.try(to_list_of_cols(rows))
  list.drop(cols, index - 1) |> list.first()
}

fn to_list_of_rows(string: String) -> Result(List(List(Int)), Nil) {
  string.split(string, "\n")
  |> list.map(fn(row) {
    string.split(row, " ")
    |> list.map(fn(string_number) { int.parse(string_number) })
    |> result.all()
  })
  |> result.all()
}

fn to_list_of_cols(rows: List(List(Int))) -> Result(List(List(Int)), Nil) {
  use first_row <- result.try(list.first(rows))
  let col_count = list.length(first_row)

  list.range(0, col_count - 1)
  |> list.map(fn(index) {
    list.map(rows, fn(row) { list.drop(row, index) |> list.first() })
    |> result.all
  })
  |> result.all
}
