import gleam/string

pub fn get_bottles(number: Int) {
  case number {
    0 -> "no green bottles"
    1 -> "one green bottle"
    2 -> "two green bottles"
    3 -> "three green bottles"
    4 -> "four green bottles"
    5 -> "five green bottles"
    6 -> "six green bottles"
    7 -> "seven green bottles"
    8 -> "eight green bottles"
    9 -> "nine green bottles"
    10 -> "ten green bottles"
    _ -> ""
  }
}

pub fn recite(start_bottles start_bottles: Int, take_down take_down: Int) {
  case take_down {
    _ if take_down > 1 -> {
      {
        string.capitalise(get_bottles(start_bottles))
        <> " hanging on the wall,\n"
        <> string.capitalise(get_bottles(start_bottles))
        <> " hanging on the wall,\n"
        <> "And if one green bottle should accidentally fall,\n"
        <> "There'll be "
        <> get_bottles(start_bottles - 1)
        <> " hanging on the wall.\n\n"
      }
      <> recite(start_bottles - 1, take_down - 1)
    }
    _ if take_down == 1 -> {
      string.capitalise(get_bottles(start_bottles))
      <> " hanging on the wall,\n"
      <> string.capitalise(get_bottles(start_bottles))
      <> " hanging on the wall,\n"
      <> "And if one green bottle should accidentally fall,\n"
      <> "There'll be "
      <> get_bottles(start_bottles - 1)
      <> " hanging on the wall."
    }
    _ -> ""
  }
}
