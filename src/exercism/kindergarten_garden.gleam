import gleam/list
import gleam/string

pub type Student {
  Alice
  Bob
  Charlie
  David
  Eve
  Fred
  Ginny
  Harriet
  Ileana
  Joseph
  Kincaid
  Larry
}

pub type Plant {
  Radishes
  Clover
  Violets
  Grass
}

pub fn plants(diagram: String, student: Student) -> List(Plant) {
  let student_index = student_index(student)
  string.split(diagram, "\n")
  |> list.map(fn(row) { get_plants(row, student_index) })
  |> list.flatten
}

fn student_index(student: Student) {
  case student {
    Alice -> 0
    Bob -> 1
    Charlie -> 2
    David -> 3
    Eve -> 4
    Fred -> 5
    Ginny -> 6
    Harriet -> 7
    Ileana -> 8
    Joseph -> 9
    Kincaid -> 10
    Larry -> 11
  }
}

fn get_plants(row: String, index: Int) -> List(Plant) {
  let start = index * 2

  string.slice(row, start, 2)
  |> string.to_graphemes
  |> list.map(fn(plant) {
    case plant {
      "R" -> Radishes
      "C" -> Clover
      "V" -> Violets
      "G" -> Grass
      _ -> panic
    }
  })
}
