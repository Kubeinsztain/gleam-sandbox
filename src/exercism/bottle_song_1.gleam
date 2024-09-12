import gleam/list
import gleam/string

pub fn get_verse(lyrics: String, number: Int) {
  let lines = string.split(lyrics, "\n")
  let start = number * 4
  let end = start + 4

  list.filter(lines, fn(x) {
    case x {
      _ if x == "" -> False
      _ -> True
    }
  })
  |> list.index_map(fn(x, i) { #(i, x) })
  |> list.filter(fn(x) {
    case x {
      #(i, _) if i >= start && i < end -> True
      _ -> False
    }
  })
  |> list.map(fn(x) { x.1 })
  |> string.join("\n")
}

pub fn get_line(lyrics: List(String), number: Int) {
  case number, lyrics {
    0, [row, ..] -> row
    _, [] -> ""
    _, [_, ..rest] -> get_line(rest, number - 1)
  }
}

pub fn recite(
  start_bottles start_bottles: Int,
  take_down take_down: Int,
) -> String {
  case take_down {
    0 -> ""
    _ -> {
      let verse = get_verse(lyrics, 10 - start_bottles)
      let rest = recite(start_bottles - 1, take_down - 1)
      case rest {
        "" -> verse
        _ -> verse <> "\n" <> "\n" <> rest
      }
    }
  }
}

const lyrics = "Ten green bottles hanging on the wall,
Ten green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be nine green bottles hanging on the wall.

Nine green bottles hanging on the wall,
Nine green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be eight green bottles hanging on the wall.

Eight green bottles hanging on the wall,
Eight green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be seven green bottles hanging on the wall.

Seven green bottles hanging on the wall,
Seven green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be six green bottles hanging on the wall.

Six green bottles hanging on the wall,
Six green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be five green bottles hanging on the wall.

Five green bottles hanging on the wall,
Five green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be four green bottles hanging on the wall.

Four green bottles hanging on the wall,
Four green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be three green bottles hanging on the wall.

Three green bottles hanging on the wall,
Three green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be two green bottles hanging on the wall.

Two green bottles hanging on the wall,
Two green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There'll be one green bottle hanging on the wall.

One green bottle hanging on the wall,
One green bottle hanging on the wall,
And if one green bottle should accidentally fall,
There'll be no green bottles hanging on the wall."
