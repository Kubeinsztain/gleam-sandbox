import gleam/erlang/process.{type Subject}
import gleam/otp/actor

pub type Msg(val) {
  Push(item: val)
  Pop(reply_with: Subject(Result(val, Nil)))
  Get(reply_with: Subject(List(val)))
  Shutdown
}

fn handle_message(
  message: Msg(val),
  stack: List(val),
) -> actor.Next(Msg(val), List(val)) {
  case message {
    // For the `Shutdown` message we return the `actor.Stop` value, which causes
    // the actor to discard any remaining messages and stop.
    Shutdown -> actor.Stop(process.Normal)

    // For the `Push` message we add the new element to the stack and return
    // `actor.continue` with this new stack, causing the actor to process any
    // queued messages or wait for more.
    Push(value) -> {
      let new_state = [value, ..stack]
      actor.continue(new_state)
    }

    // For the `Pop` message we attempt to remove an element from the stack,
    // sending it or an error back to the caller, before continuing.
    Pop(client) -> {
      case stack {
        [] -> {
          // When the stack is empty we can't pop an element, so we send an
          // error back.
          process.send(client, Error(Nil))
          actor.continue([])
        }

        [first, ..rest] -> {
          // Otherwise we send the first element back and use the remaining
          // elements as the new state.
          process.send(client, Ok(first))
          actor.continue(rest)
        }
      }
    }

    Get(client) -> {
      process.send(client, stack)
      actor.continue(stack)
    }
  }
}

pub fn main() {
  let assert Ok(my_actor) = actor.start([], handle_message)

  actor.call(my_actor, Get, 1000) |> echo

  actor.send(my_actor, Push("Janusz"))
  actor.send(my_actor, Push("Dariusz"))
  actor.send(my_actor, Push("Andrzej"))

  actor.call(my_actor, Get, 1000) |> echo

  actor.call(my_actor, Pop, 1000) |> echo
  actor.call(my_actor, Pop, 1000) |> echo
  actor.call(my_actor, Pop, 1000) |> echo
  actor.call(my_actor, Pop, 1000) |> echo

  process.send(my_actor, Shutdown)
}
