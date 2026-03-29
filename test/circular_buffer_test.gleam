import exercism/circular_buffer
import gleeunit

pub fn main() {
  gleeunit.main()
}

// pub fn initial_clear_does_not_affect_wrapping_around_test() {
//   let buffer = circular_buffer.new(2)
//   let buffer = circular_buffer.clear(buffer)
//   let assert Ok(buffer) = circular_buffer.write(buffer, 1)
//   let assert Ok(buffer) = circular_buffer.write(buffer, 2)
//   let buffer = circular_buffer.overwrite(buffer, 3)
//   let buffer = circular_buffer.overwrite(buffer, 4)
//   let assert Ok(#(3, buffer)) = circular_buffer.read(buffer)
//   let assert Ok(#(4, buffer)) = circular_buffer.read(buffer)
//   let assert Error(_) = circular_buffer.read(buffer)
// }

pub fn overwrite_acts_like_write_on_non_full_buffer_test() {
  let buffer = circular_buffer.new(2)
  let assert Ok(buffer) = circular_buffer.write(buffer, 1)
  let buffer = circular_buffer.overwrite(buffer, 2)
  let assert Ok(#(1, buffer)) = circular_buffer.read(buffer)
  let assert Ok(#(2, _)) = circular_buffer.read(buffer)
}
