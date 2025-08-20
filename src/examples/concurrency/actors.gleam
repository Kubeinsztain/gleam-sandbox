import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/result

pub type Message(element) {
  Push(push: element)
  Pop(reply_with: Subject(Result(element, Nil)))
  Shutdown
}

pub fn start() {
  use actor <- result.try(create_new_actor() |> result.map_error(fn(_) { Nil }))

  let subject = actor.data
  process.send(subject, Push("Person 1"))
  process.send(subject, Push("Person 2"))
  process.send(subject, Push("Person 3"))

  echo actor

  use person_3 <- result.try(process.call(subject, 10, Pop))
  echo person_3
  use person_2 <- result.try(process.call(subject, 10, Pop))
  echo person_2
  use person_1 <- result.try(process.call(subject, 10, Pop))
  echo person_1

  use whatever <- result.try(process.call(subject, 10, Pop))
  echo "Whatever should appear"
  echo whatever

  Ok(actor)
}

fn create_new_actor() {
  actor.new([]) |> actor.on_message(handle_message) |> actor.start
}

fn handle_message(
  stack: List(e),
  message: Message(e),
) -> actor.Next(List(e), Message(e)) {
  case message {
    Shutdown -> actor.stop()
    Push(value) -> {
      let new_state = [value, ..stack]
      actor.continue(new_state)
    }
    Pop(client) -> {
      case stack {
        [] -> {
          process.send(client, Error(Nil))
          actor.continue([])
        }

        [first, ..rest] -> {
          process.send(client, Ok(first))
          actor.continue(rest)
        }
      }
    }
  }
}
