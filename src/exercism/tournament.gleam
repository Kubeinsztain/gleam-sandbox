import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/order.{type Order, Eq, Gt, Lt}
import gleam/string

type Game =
  #(String, String, String)

type Stat =
  Dict(String, Int)

type Team =
  #(String, Stat)

fn sort_records(a: Team, b: Team) -> Order {
  let #(team_a, stats_a) = a
  let #(team_b, stats_b) = b

  let points_a = get_stat(stats_a, "P")
  let points_b = get_stat(stats_b, "P")

  case int.compare(points_a, points_b) {
    Lt -> Gt
    Eq -> {
      case string.compare(team_a, team_b) {
        Lt -> Lt
        Eq -> Eq
        Gt -> Gt
      }
    }
    Gt -> Lt
  }
}

pub fn tally(input: String) -> String {
  let header = "Team                           | MP |  W |  D |  L |  P"

  let results = case input |> string.length {
    0 -> ""
    _ ->
      input
      |> string.split("\n")
      |> list.map(extract_game)
      |> prepare_stats
      |> list.sort(sort_records)
      |> list.map(team_record)
      |> string.join("\n")
      |> string.append("\n", _)
  }
  string.concat([header, results])
}

fn extract_game(line: String) -> Game {
  case string.split(line, ";") {
    [home, away, outcome, ..] -> {
      #(home, away, outcome)
    }
    _ -> panic
  }
}

fn prepare_stats(games: List(Game)) -> List(#(String, Dict(String, Int))) {
  list.fold(games, [], fn(acc, game) {
    let #(home, away, outcome) = game
    let home_score = case outcome {
      "win" -> 3
      "loss" -> 0
      "draw" -> 1
      _ -> panic
    }
    let away_score = case outcome {
      "win" -> 0
      "loss" -> 3
      "draw" -> 1
      _ -> panic
    }

    let home_stats = find_stats(acc, home)
    let away_stats = find_stats(acc, away)

    let home_entry = #(home, update_stats(home_stats, home_score))
    let away_entry = #(away, update_stats(away_stats, away_score))

    list.filter(acc, fn(entry) {
      let #(team, _) = entry
      team != home && team != away
    })
    |> list.append([home_entry, away_entry])
  })
}

fn get_stat(stats: Dict(String, Int), stat: String) -> Int {
  case dict.get(stats, stat) {
    Ok(value) -> value
    Error(_) -> panic
  }

  let assert Ok(val) = dict.get(stats, stat)
  val
}

fn find_stats(
  stats: List(#(String, Dict(String, Int))),
  team_name: String,
) -> Dict(String, Int) {
  case
    list.find(stats, fn(entry) {
      let #(team, _) = entry
      team == team_name
    })
  {
    Ok(#(_, stats)) -> stats
    Error(_) -> dict.new()
  }
}

fn update_stats(stats: Dict(String, Int), score: Int) -> Dict(String, Int) {
  dict.upsert(stats, "MP", fn(played) {
    case played {
      Some(value) -> value + 1
      None -> 1
    }
  })
  |> dict.upsert("W", fn(won) {
    case score, won {
      3, Some(value) -> value + 1
      _, Some(value) -> value
      3, None -> 1
      _, None -> 0
    }
  })
  |> dict.upsert("D", fn(won) {
    case score, won {
      1, Some(value) -> value + 1
      _, Some(value) -> value
      1, None -> 1
      _, None -> 0
    }
  })
  |> dict.upsert("L", fn(won) {
    case score, won {
      0, Some(value) -> value + 1
      _, Some(value) -> value
      0, None -> 1
      _, None -> 0
    }
  })
  |> dict.upsert("P", fn(points) {
    case points {
      Some(value) -> value + score
      None -> score
    }
  })
}

fn dict_value_to_stat(d: Dict(String, Int), key: String) -> String {
  let assert Ok(value) = dict.get(d, key)

  case value |> int.to_string |> string.length {
    _ if value < 10 -> string.concat(["  ", int.to_string(value)])
    _ if value > 10 -> string.concat([" ", int.to_string(value)])
    _ -> panic
  }
}

fn team_record(entry: Team) -> String {
  let #(team, stats) = entry

  let played = dict_value_to_stat(stats, "MP")
  let won = dict_value_to_stat(stats, "W")
  let drawn = dict_value_to_stat(stats, "D")
  let lost = dict_value_to_stat(stats, "L")
  let points = dict_value_to_stat(stats, "P")

  let padding = {
    30 - string.length(team)
    |> list.range(0, _)
    |> list.fold("", fn(acc, _) { string.append(acc, " ") })
  }

  string.concat([
    team,
    padding,
    "|",
    played,
    " |",
    won,
    " |",
    drawn,
    " |",
    lost,
    " |",
    points,
  ])
}
