import gleam/bool
import gleam/dict
import gleam/list
import gleam/string

pub type School {
  School(dict.Dict(Int, List(String)))
}

pub fn create() -> School {
  School(dict.new())
}

pub fn roster(school: School) -> List(String) {
  case school {
    School(roster) -> {
      dict.values(roster)
      |> list.map(fn(students) { students |> list.sort(string.compare) })
      |> list.flatten()
    }
  }
}

pub fn add(
  to school: School,
  student student: String,
  grade grade: Int,
) -> Result(School, Nil) {
  // validate if the student is not added already
  use <- bool.guard(already_exists(school, student), Error(Nil))

  case grade {
    x if x > 0 -> {
      let School(roster) = school
      case dict.get(roster, grade) {
        Ok(students) -> {
          echo "Found existing grade"
          let updated_students = [student, ..students]
          let updated_roster = dict.insert(roster, grade, updated_students)
          Ok(School(updated_roster))
        }
        Error(_) -> {
          echo "Creating new grade"
          let updated_roster = dict.insert(roster, grade, [student])
          Ok(School(updated_roster))
        }
      }
    }
    _ -> Error(Nil)
  }
}

pub fn grade(school: School, desired_grade: Int) -> List(String) {
  echo "School"
  echo school
  case school {
    School(roster) -> {
      case dict.get(roster, desired_grade) {
        Ok(students) -> students
        Error(_) -> []
      }
    }
  }
}

fn already_exists(school: School, student: String) {
  let School(roster) = school

  let student_list =
    dict.fold(roster, [], fn(acc, _, val) { list.append(acc, val) })

  let found = list.find(student_list, fn(item) { item == student })

  case found {
    Ok(_) -> True
    Error(_) -> False
  }
}
