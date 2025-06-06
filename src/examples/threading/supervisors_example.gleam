import gleam/erlang/process.{type Pid, type Subject}
import gleam/function
import gleam/int
import gleam/otp/actor
import gleam/otp/static_supervisor.{type ChildBuilder, OneForOne}
import prng/random

pub type Msg {
  Msg(reply_to: Subject(Result(String, Nil)))
}

pub fn run() {
  let supervisor = static_supervisor.new(OneForOne)

  supervisor
  |> static_supervisor.add(
    static_supervisor.worker_child("first", fn() { todo }),
  )
}

fn child_starter() -> Result(Pid, a) {
  todo
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
