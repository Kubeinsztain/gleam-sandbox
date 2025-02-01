pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  case second {
    [] -> first
    [_, ..] -> prepend(reverse(first), second)
  }
}

fn prepend(list: List(a), acc: List(a)) -> List(a) {
  case list {
    [] -> acc
    [head, ..rest] -> prepend(rest, [head, ..acc])
  }
}

pub fn concat(lists: List(List(a))) -> List(a) {
  foldl(lists, [], append)
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  list_filter_loop(list, function, []) |> reverse
}

fn list_filter_loop(
  list: List(a),
  function: fn(a) -> Bool,
  acc: List(a),
) -> List(a) {
  case list {
    [] -> acc
    [head, ..rest] -> {
      case function(head) {
        True -> list_filter_loop(rest, function, [head, ..acc])
        False -> list_filter_loop(rest, function, acc)
      }
    }
  }
}

pub fn length(list: List(a)) -> Int {
  list_length_loop(list, 0)
}

fn list_length_loop(list: List(a), acc: Int) -> Int {
  case list {
    [] -> acc
    [_, ..rest] -> list_length_loop(rest, acc + 1)
  }
}

pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  list_map_loop(list, function, []) |> reverse
}

fn list_map_loop(list: List(a), function: fn(a) -> b, acc: List(b)) -> List(b) {
  case list {
    [] -> acc
    [head, ..rest] -> list_map_loop(rest, function, [function(head), ..acc])
  }
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [head, ..rest] -> foldl(rest, function(initial, head), function)
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  foldl(reverse(list), initial, function)
}

pub fn reverse(list: List(a)) -> List(a) {
  list_reverse_loop(list, [])
}

fn list_reverse_loop(list: List(a), acc: List(a)) -> List(a) {
  case list {
    [] -> acc
    [head, ..rest] -> list_reverse_loop(rest, [head, ..acc])
  }
}
