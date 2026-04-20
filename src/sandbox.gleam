import exercism/killer_sudoku_helper

pub fn main() {
  let size = 2
  let sum = 10

  let result = killer_sudoku_helper.combinations(size, sum, [1, 4])

  echo result
}
