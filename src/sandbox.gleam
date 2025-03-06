import exercism/nth_prime
import gleam/io

pub fn main() {
  nth_prime.prime(6) |> io.debug
}
