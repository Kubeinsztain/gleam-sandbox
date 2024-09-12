pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  case list {
    [] -> []
    [x, ..rest] -> [fun(x), ..accumulate(rest, fun)]
  }
}
