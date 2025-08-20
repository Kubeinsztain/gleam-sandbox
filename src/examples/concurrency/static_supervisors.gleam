import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/otp/static_supervisor as supervisor
import gleam/otp/supervision
import gleam/result

pub type Response(a) {
  Down
  Payload(a)
  Other
}

pub fn start() {
  let parent_subject = process.new_subject()

  let worker = get_worker(parent_subject)

  let sup =
    supervisor.new(supervisor.OneForOne)
    |> supervisor.add(worker)
    |> supervisor.start()

  use _started_supervisor <- result.try(sup |> result.map_error(fn(_) { Nil }))

  use worker <- result.try(
    process.receive(parent_subject, 1000) |> result.map_error(fn(_) { Nil }),
  )

  // Monitor the worker process so we know when it dies
  use pid <- result.try(
    process.subject_owner(worker) |> result.map_error(fn(_) { Nil }),
  )
  // Here we are running the monitoring - without it we won't receive the ProcessDown message
  echo process.monitor(pid)

  echo "Sending message to worker"
  actor.send(worker, Off)

  // Create a selector that can receive monitor down messages AND parent subject messages
  let selector =
    process.new_selector()
    |> process.select_map(parent_subject, fn(message) { Payload(message) })
    |> process.select_monitors(fn(message) {
      echo message
      Down
    })

  // Wait for the ProcessDown message using selector_receive
  use message <- result.try(process.selector_receive(selector, 5000))

  echo "Received message:"
  echo message

  use message <- result.try(process.selector_receive(selector, 5000))

  echo "Received message:"
  echo message

  Ok(message)
}

fn get_worker(parent_subject: Subject(Subject(Message(String)))) {
  supervision.worker(run: fn() { create_new_actor(parent_subject) })
}

pub type Message(b) {
  Info(b)
  Off
}

fn create_new_actor(parent_subject: Subject(Subject(Message(String)))) {
  actor.new_with_initialiser(3000, fn(subject) {
    echo "Initializing actor"
    echo "Parent subject"
    echo parent_subject
    echo "Worker subject"
    echo subject

    // sending message to parent with the child subject
    // so the parent will know where to send messages to
    process.send(parent_subject, subject)

    let initialised = actor.initialised(Nil)
    Ok(initialised)
  })
  |> actor.on_message(handle_message)
  |> actor.start
}

// ...existing code...

fn handle_message(
  state: Nil,
  message: Message(String),
) -> actor.Next(Nil, Message(String)) {
  echo "Worker received a message"
  case message {
    Info(b) -> {
      echo "Worker state"
      echo b
      actor.continue(state)
    }
    Off -> {
      echo "Shutting down the worker"
      actor.stop()
    }
  }
}
