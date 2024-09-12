import gleam/int
import gleam/float
import gleam/string

pub fn pence_to_pounds(pence: Int) -> Float {
  let rate = 1.0 /. 100.0
  rate *. int.to_float(pence)
}

pub fn pounds_to_string(pounds) {
  string.append("£", float.to_string(pounds))
}