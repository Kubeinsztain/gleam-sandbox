import gleam/list
import gleam/set.{type Set}
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  let exists = set.contains(collection, card)
  case exists {
    True -> #(True, collection)
    False -> #(False, set.insert(collection, card))
  }
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  let my_card_in_set = set.contains(collection, my_card)
  let their_card_in_set = set.contains(collection, their_card)

  let new_collection =
    collection |> set.delete(my_card) |> set.insert(their_card)

  case my_card_in_set, their_card_in_set {
    True, False -> #(True, new_collection)
    _, _ -> #(False, new_collection)
  }
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  let first_collection = list.first(collections)

  case first_collection {
    Error(Nil) -> []
    Ok(first) -> {
      list.fold(collections, first, fn(acc, collection) {
        set.intersection(acc, collection)
      })
      |> set.to_list
    }
  }
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  list.fold(collections, set.new(), fn(acc, collection) {
    set.union(acc, collection)
  })
  |> set.size
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.fold(collection, set.new(), fn(acc, card) {
    case string.starts_with(card, "Shiny ") {
      True -> set.insert(acc, card)
      False -> acc
    }
  })
}
