import gleam/bool
import gleam/list
import gleam/result

pub opaque type CircularBuffer(t) {
  CircularBuffer(values: List(t), capacity: Int)
}

pub fn new(capacity: Int) -> CircularBuffer(t) {
  CircularBuffer([], capacity)
}

pub fn read(buffer: CircularBuffer(t)) -> Result(#(t, CircularBuffer(t)), Nil) {
  let CircularBuffer(values, capacity) = buffer

  use <- bool.guard(list.is_empty(values), Error(Nil))
  use #(item, rest) <- result.try(pop_item(values))

  Ok(#(item, CircularBuffer(rest, capacity)))
}

pub fn write(
  buffer: CircularBuffer(t),
  item: t,
) -> Result(CircularBuffer(t), Nil) {
  use <- bool.guard(is_buffer_full(buffer), Error(Nil))
  Ok(add_item_to_buffer(buffer, item))
}

pub fn overwrite(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  use <- bool.guard(!is_buffer_full(buffer), add_item_to_buffer(buffer, item))

  let CircularBuffer(values, capacity) = buffer
  let assert Ok(#(_, rest)) = pop_item(values)
  CircularBuffer([item, ..rest], capacity)
}

pub fn clear(buffer: CircularBuffer(t)) -> CircularBuffer(t) {
  let CircularBuffer(_, capacity) = buffer
  CircularBuffer([], capacity)
}

fn add_item_to_buffer(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  let CircularBuffer(values, capacity) = buffer
  CircularBuffer([item, ..values], capacity)
}

fn pop_item(items: List(t)) {
  case list.reverse(items) {
    [item, ..rest] -> Ok(#(item, list.reverse(rest)))
    [] -> Error(Nil)
  }
}

fn is_buffer_full(buffer: CircularBuffer(t)) -> Bool {
  let CircularBuffer(values, capacity) = buffer
  list.length(values) >= capacity
}
