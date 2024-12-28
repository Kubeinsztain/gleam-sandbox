import gleam/dict
import gleam/list
import gleam/option.{None, Some}

pub type Category {
  Ones
  Twos
  Threes
  Fours
  Fives
  Sixes
  FullHouse
  FourOfAKind
  LittleStraight
  BigStraight
  Choice
  Yacht
}

pub fn score(category: Category, dice: List(Int)) -> Int {
  case category {
    Ones -> sum_dices(dice, 1)
    Twos -> sum_dices(dice, 2)
    Threes -> sum_dices(dice, 3)
    Fours -> sum_dices(dice, 4)
    Fives -> sum_dices(dice, 5)
    Sixes -> sum_dices(dice, 6)
    FullHouse -> full_house(dice)
    FourOfAKind -> four_of_a_kind(dice)
    LittleStraight -> little_straight(dice)
    BigStraight -> big_straight(dice)
    Choice -> list.fold(dice, 0, fn(acc, value) { acc + value })
    Yacht -> yacht(dice)
  }
}

fn sum_dices(dice: List(Int), dice_number: Int) -> Int {
  list.fold(dice, 0, fn(acc, value) {
    case value == dice_number {
      True -> acc + value
      False -> acc
    }
  })
}

fn full_house(dice: List(Int)) {
  let dice_dict = count_unique(dice)
  case dict.values(dice_dict) {
    [2, 3] -> list.fold(dice, 0, fn(acc, value) { acc + value })
    [3, 2] -> list.fold(dice, 0, fn(acc, value) { acc + value })
    _ -> 0
  }
}

fn four_of_a_kind(dice: List(Int)) {
  count_unique(dice)
  |> dict.fold(0, fn(acc, key, value) {
    case value >= 4 {
      True -> key * 4
      False -> acc
    }
  })
}

fn little_straight(dice: List(Int)) {
  let selection = [1, 2, 3, 4, 5]
  let selection_dict = count_unique(dice) |> dict.take(selection)
  case dict.size(selection_dict) == 5 {
    True -> 30
    False -> 0
  }
}

fn big_straight(dice: List(Int)) {
  let selection = [2, 3, 4, 5, 6]
  let selection_dict = count_unique(dice) |> dict.take(selection)
  case dict.size(selection_dict) == 5 {
    True -> 30
    False -> 0
  }
}

fn yacht(dice: List(Int)) {
  let dice_dict = count_unique(dice)
  case dict.size(dice_dict) == 1 {
    True -> 50
    False -> 0
  }
}

fn count_unique(dice: List(Int)) {
  let increment = fn(x) {
    case x {
      Some(i) -> i + 1
      None -> 1
    }
  }

  list.fold(dice, dict.new(), fn(acc, value: Int) {
    dict.upsert(acc, value, increment)
  })
}
