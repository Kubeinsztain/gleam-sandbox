import gleam/erlang/process.{type Subject}
import gleam/function
import gleam/int
import gleam/io
import gleam/otp/actor
import prng/random

pub type Msg {
  Msg(reply_to: Subject(Result(String, Nil)))
}

fn handle_message(msg: Msg, state) {
  let gen = random.weighted(#(0.1, False), [#(0.9, True)])
  case random.random_sample(gen) {
    True -> {
      actor.send(msg.reply_to, Ok("Fine"))
      actor.continue(state)
    }
    False -> {
      actor.send(msg.reply_to, Error(Nil))
      actor.Stop(process.Abnormal("Worker failed"))
    }
  }
}

pub fn run() {
  let parent = process.new_subject()
  let assert Ok(worker) = new(Nil, parent)

  run_actor(parent, worker, 100)
}

fn new(_arg: Nil, parent: Subject(Subject(Msg))) {
  actor.start_spec(actor.Spec(
    init: fn() {
      let subj = process.new_subject()
      process.send(parent, subj)

      process.new_selector()
      |> process.selecting(subj, function.identity)
      |> actor.Ready(Nil, _)
    },
    init_timeout: 1000,
    loop: handle_message,
  ))
}

fn run_actor(
  parent: Subject(Subject(Msg)),
  worker: Subject(Msg),
  times: Int,
) -> Subject(Msg) {
  echo worker

  case times {
    0 -> worker
    _ -> {
      case process.try_call(worker, fn(self) { Msg(self) }, 1000) {
        Ok(_) -> run_actor(parent, worker, times - 1)
        Error(_) -> {
          // Crash - get a new subject
          let assert Ok(new_worker) = new(Nil, parent)
          io.println("Crashed on " <> int.to_string(100 - times))
          run_actor(parent, new_worker, times - 1)
        }
      }
    }
  }
}
