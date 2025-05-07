import gleam/string

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction, position)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  case instructions {
    "" -> Robot(direction, position)
    ins -> {
      let remaining = string.drop_start(ins, 1)
      case string.first(ins) {
        Ok("A") -> {
          let new_position = advance(direction, position)
          move(direction, new_position, remaining)
        }
        Ok("L") -> {
          let new_direction = turn_left(direction)
          move(new_direction, position, remaining)
        }
        Ok("R") -> {
          let new_direction = turn_right(direction)
          move(new_direction, position, remaining)
        }
        _ -> Robot(direction, position)
      }
    }
  }
}

pub fn turn_left(direction: Direction) -> Direction {
  case direction {
    North -> West
    East -> North
    South -> East
    West -> South
  }
}

pub fn turn_right(direction: Direction) -> Direction {
  case direction {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}

pub fn advance(direction: Direction, position: Position) -> Position {
  case direction {
    North -> Position(position.x, position.y + 1)
    East -> Position(position.x + 1, position.y)
    South -> Position(position.x, position.y - 1)
    West -> Position(position.x - 1, position.y)
  }
}
