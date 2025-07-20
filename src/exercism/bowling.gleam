import gleam/bool
import gleam/list
import gleam/result

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

fn pin_count_invalid(pins: Int) -> Bool {
  pins > 10 || pins < 0
}

fn is_game_complete(game: Game) -> Bool {
  case list.length(game.frames) {
    10 -> {
      // Check the 10th frame (first in the list since frames are in reverse order)
      let tenth_frame = case game.frames {
        [frame, ..] -> frame
        [] -> Frame([], [])
      }
      // Game is complete when 10th frame has enough rolls
      case tenth_frame.rolls {
        [10, _, _] -> True
        // Strike + 2 bonus rolls
        [a, b, _] if a + b == 10 -> True
        // Spare + 1 bonus roll
        [a, b] if a + b < 10 -> True
        // Open frame
        _ -> False
      }
    }
    x if x < 10 -> False
    _ -> True
    // More than 10 frames shouldn't happen
  }
}

fn is_strike(frame: Frame) -> Bool {
  case frame.rolls {
    [10, ..] -> True
    _ -> False
  }
}

fn is_spare(frame: Frame) -> Bool {
  case frame.rolls {
    [a, b] if a + b == 10 && a != 10 -> True
    _ -> False
  }
}

fn frame_is_complete(frame: Frame, frame_number: Int) -> Bool {
  case frame_number {
    10 -> {
      // 10th frame logic
      case frame.rolls {
        [10, _, _] -> True
        // Strike + 2 fills
        [a, b, _] if a + b == 10 -> True
        // Spare + 1 fill
        [a, b] if a + b < 10 -> True
        // Open frame
        _ -> False
      }
    }
    _ -> {
      // Frames 1-9
      case frame.rolls {
        [10] -> True
        // Strike
        [_, _] -> True
        // Two rolls
        _ -> False
      }
    }
  }
}

fn validate_roll(game: Game, pins: Int) -> Result(Nil, Error) {
  use <- bool.guard(pin_count_invalid(pins), Error(InvalidPinCount))
  use <- bool.guard(is_game_complete(game), Error(GameComplete))

  let frames_count = list.length(game.frames)

  // Special validation for 10th frame
  case frames_count {
    10 -> {
      let tenth_frame = case game.frames {
        [frame, ..] -> frame
        [] -> Frame([], [])
      }
      validate_tenth_frame_roll(tenth_frame, pins)
    }
    _ -> {
      // Regular frame validation (1-9)
      case game.frames {
        [Frame([first_roll], _), ..] if first_roll != 10 -> {
          // Only validate if first roll wasn't a strike
          use <- bool.guard(first_roll + pins > 10, Error(InvalidPinCount))
          Ok(Nil)
        }
        _ -> Ok(Nil)
      }
    }
  }
}

fn validate_tenth_frame_roll(frame: Frame, pins: Int) -> Result(Nil, Error) {
  case frame.rolls {
    [] -> Ok(Nil)
    // First roll of 10th frame
    [10] -> Ok(Nil)
    // After strike, any roll is valid
    [10, 10] -> Ok(Nil)
    // After two strikes, any roll is valid
    [10, a] if a != 10 -> {
      // After strike + non-strike, total can't exceed 10
      use <- bool.guard(a + pins > 10, Error(InvalidPinCount))
      Ok(Nil)
    }
    [a] if a != 10 -> {
      // After non-strike first roll, check if spare is possible
      Ok(Nil)
      // Any second roll is valid (even if it creates spare)
    }
    [a, b] if a + b == 10 -> Ok(Nil)
    // After spare, any bonus roll is valid
    [a, b] if a + b < 10 -> Error(InvalidPinCount)
    // Shouldn't get here if frame complete
    _ -> Error(InvalidPinCount)
  }
}

pub fn roll(game: Game, pins: Int) -> Result(Game, Error) {
  use _ <- result.try(validate_roll(game, pins))

  let frame_count = list.length(game.frames)

  case game.frames {
    // No frames yet - create first frame
    [] -> {
      let new_frame = Frame([pins], [])
      Ok(Game([new_frame]))
    }

    // Current frame exists
    [current_frame, ..rest] -> {
      // Frame number: 1-based, counting from the end
      let current_frame_number = frame_count

      case frame_is_complete(current_frame, current_frame_number) {
        // Current frame is complete - start new frame (unless we're at 10 frames)
        True if frame_count < 10 -> {
          let new_frame = Frame([pins], [])
          let updated_frames =
            add_bonuses([new_frame, current_frame, ..rest], pins)
          Ok(Game(updated_frames))
        }

        // Current frame is not complete - add roll to current frame
        False -> {
          let updated_rolls = list.append(current_frame.rolls, [pins])
          let updated_current = Frame(updated_rolls, current_frame.bonus)
          let updated_frames = add_bonuses([updated_current, ..rest], pins)
          Ok(Game(updated_frames))
        }

        // Frame is complete and we're at 10 frames - game should be complete
        True -> Error(GameComplete)
      }
    }
  }
}

fn add_bonuses(frames: List(Frame), pins: Int) -> List(Frame) {
  case frames {
    [current] -> [current]
    [current, previous] -> [current, add_bonus_if_needed(previous, pins)]
    [current, previous, second_previous, ..rest] -> [
      current,
      add_bonus_if_needed(previous, pins),
      add_bonus_if_needed_for_second(second_previous, pins),
      ..rest
    ]
    [] -> []
  }
}

fn add_bonus_if_needed(frame: Frame, pins: Int) -> Frame {
  case is_strike(frame) {
    True -> {
      // Strike needs 2 bonuses
      case list.length(frame.bonus) < 2 {
        True -> Frame(frame.rolls, list.append(frame.bonus, [pins]))
        False -> frame
        // Already has 2 bonuses
      }
    }
    False -> {
      case is_spare(frame) {
        True -> {
          // Spare needs 1 bonus
          case list.is_empty(frame.bonus) {
            True -> Frame(frame.rolls, list.append(frame.bonus, [pins]))
            False -> frame
            // Already has 1 bonus
          }
        }
        False -> frame
        // Open frame, no bonus needed
      }
    }
  }
}

fn add_bonus_if_needed_for_second(frame: Frame, pins: Int) -> Frame {
  case is_strike(frame) && list.length(frame.bonus) < 2 {
    True -> Frame(frame.rolls, list.append(frame.bonus, [pins]))
    False -> frame
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  use <- bool.guard(!is_game_complete(game), Error(GameNotComplete))

  let frame_scores =
    list.map(game.frames, fn(frame) {
      list.fold(frame.rolls, 0, fn(acc, roll) { acc + roll })
      + list.fold(frame.bonus, 0, fn(acc, bonus) { acc + bonus })
    })

  Ok(list.fold(frame_scores, 0, fn(acc, score) { acc + score }))
}
