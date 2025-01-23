import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/string

type Cord =
  #(Int, Int)

pub fn rectangles(input: String) -> Int {
  let dict_of_cords = input |> to_cords_dict

  let corners = safe_dict_list_extract(dict_of_cords, "+")

  list.combination_pairs(corners)
  |> list.fold(0, fn(acc, entry) {
    let #(cord1, cord2) = entry
    let #(row1, col1) = cord1
    let #(row2, col2) = cord2

    let valid_diagonal = row1 < row2 && col1 < col2

    let all_corners =
      list.contains(corners, #(row1, col2))
      && list.contains(corners, #(row2, col1))

    case valid_diagonal, all_corners {
      True, True -> {
        let horizontal_validation =
          validate_horizontal_edges(dict_of_cords, cord1, cord2)

        let vertical_validation =
          validate_vertical_edges(dict_of_cords, cord1, cord2)
        case horizontal_validation, vertical_validation {
          True, True -> acc + 1
          _, _ -> acc
        }
      }
      _, _ -> acc
    }
  })
}

fn to_cords_dict(input: String) -> Dict(String, List(Cord)) {
  string.split(input, "\n")
  |> list.index_fold(dict.new(), fn(acc, line, row_index) {
    string.to_graphemes(line)
    |> list.index_fold(dict.new(), fn(acc, char, col_index) {
      case char {
        " " -> acc
        _ ->
          upsert_dicts_with_lists(
            acc,
            dict.from_list([#(char, [#(row_index, col_index)])]),
          )
      }
    })
    |> upsert_dicts_with_lists(acc, _)
  })
}

fn upsert_dicts_with_lists(
  first: Dict(String, List(Cord)),
  second: Dict(String, List(Cord)),
) -> Dict(String, List(Cord)) {
  dict.to_list(second)
  |> list.fold(first, fn(acc, entry) {
    let #(key, cords) = entry
    dict.upsert(acc, key, fn(existing_cords) {
      case existing_cords {
        Some(data) -> list.append(data, cords)
        None -> cords
      }
    })
  })
}

fn validate_horizontal_edges(
  dict_of_cords: Dict(String, List(Cord)),
  start: Cord,
  end: Cord,
) -> Bool {
  let #(row1, col1) = start
  let #(row2, col2) = end

  let corners = safe_dict_list_extract(dict_of_cords, "+")
  let horizontal_edges = safe_dict_list_extract(dict_of_cords, "-")

  let combined_cords = list.append(corners, horizontal_edges)

  validate_horizontal_edge(combined_cords, row1, col1, col2)
  && validate_horizontal_edge(combined_cords, row2, col1, col2)
}

fn validate_horizontal_edge(cords: List(Cord), row: Int, start: Int, end: Int) {
  end - start == 1
  || list.range(start + 1, end - 1)
  |> list.all(fn(col) { list.contains(cords, #(row, col)) })
}

fn validate_vertical_edges(
  dict_of_cords: Dict(String, List(Cord)),
  start: Cord,
  end: Cord,
) -> Bool {
  let #(row1, col1) = start
  let #(row2, col2) = end

  let corners = safe_dict_list_extract(dict_of_cords, "+")
  let vertical_edges = safe_dict_list_extract(dict_of_cords, "|")

  let combined_cords = list.append(corners, vertical_edges)

  validate_vertical_edge(combined_cords, col1, row1, row2)
  && validate_vertical_edge(combined_cords, col2, row1, row2)
}

fn validate_vertical_edge(
  cords: List(Cord),
  col: Int,
  start: Int,
  end: Int,
) -> Bool {
  end - start == 1
  || list.range(start + 1, end - 1)
  |> list.all(fn(row) { list.contains(cords, #(row, col)) })
}

fn safe_dict_list_extract(
  collection: Dict(String, List(#(Int, Int))),
  key: String,
) -> List(#(Int, Int)) {
  case dict.get(collection, key) {
    Ok(data) -> data
    _ -> []
  }
}
