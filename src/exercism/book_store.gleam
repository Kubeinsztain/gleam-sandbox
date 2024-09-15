import gleam/int
import gleam/list

pub fn lowest_price(books: List(Int)) -> Float {
  books
  // Sorting here is crucial for the algorithm to work
  // See the case for "n" in the unique_books_count function
  |> list.sort(int.compare)
  |> unique_books_count
  // As well as here after we have counted the unique books
  // Because later we will fill the gaps by adding 0s 
  |> list.sort(int.compare)
  |> fill_set
  |> calculate_price
  |> int.to_float
}

// This function is transforming an array of different book numbers
// into an array of the number of books of each type
// for example from [1, 1, 2, 2, 3, 3, 4, 5] to [2, 2, 2, 1, 1]
// different example from [1, 2] to [1, 1]
fn unique_books_count(books: List(Int)) -> List(Int) {
  use counts, book <- list.fold(over: books, from: [])
  // Determine the index of the book count in the array
  case book - list.length(counts) {
    // If the book count is already in the array
    0 -> {
      let assert [head, ..tail] = counts
      [head + 1, ..tail]
    }
    // If the book count is not in the array
    // We will set the count of unique book to 1 and fill the rest indexes with 0s
    // And at the end we will append the already counted books
    n -> list.concat([[1], list.repeat(0, n - 1), counts])
  }
}

// This function is filling in the gaps for arrays with length less than 5
// for example from [1, 1] to [1, 1, 0, 0, 0]
fn fill_set(counts: List(Int)) -> List(Int) {
  case list.length(counts) {
    5 -> counts
    _ ->
      [0, ..counts]
      |> fill_set
  }
}

// Calculate the price of the provided counts of unique books
fn calculate_price(counts: List(Int)) -> Int {
  // Helper function to calculate the price of a given set of books
  let price_of_set = fn(set: List(Int), price: Int) -> Int {
    counts
    // "Take" the batch of books
    |> take(set)
    // Sort the rest
    |> list.sort(int.compare)
    // Calculate the price of the rest
    |> calculate_price()
    // After all the recursion is done sum up the prices
    |> int.add(price)
  }

  case counts {
    [0, 0, 0, 0, count] -> 800 * count
    [0, 0, 0, _, _] -> price_of_set([0, 0, 0, 1, 1], 1520)
    [0, 0, _, _, _] -> price_of_set([0, 0, 1, 1, 1], 2160)
    [0, _, _, _, _] -> price_of_set([0, 1, 1, 1, 1], 2560)
    [_, _, _, _, _] -> {
      // For this case we need to find the minimum price
      // for the cases mentioned in the instructions
      // so we can determine the lowest price
      let set_of_5 = price_of_set([1, 1, 1, 1, 1], 3000)
      let set_of_4 = price_of_set([0, 1, 1, 1, 1], 2560)
      int.min(set_of_5, set_of_4)
    }
    // If the counts array is not matching any of the cases
    _ -> panic
  }
}

// Map over provided count of unique books ("from")
// and return the count of unique books
// reduced by the pattern given in "set"
fn take(from: List(Int), set: List(Int)) -> List(Int) {
  use n, count <- list.map2(set, from)
  count - n
}
