import gleam/float

pub fn score(x: Float, y: Float) -> Int {
  let distance = distance(x, y)

  case distance {
    x if x >. 10.0 -> 0
    x if x >. 5.0 -> 1
    x if x >. 1.0 -> 5
    x if x >=. 0.0 -> 10
    _ -> 0
  }
}

fn distance(x: Float, y: Float) -> Float {
  let squared = {
    x *. x +. y *. y
  }

  case float.square_root(squared) {
    Ok(value) -> value
    Error(_) -> 0.0
  }
}
