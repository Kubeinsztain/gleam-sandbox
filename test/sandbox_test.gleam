import exercism/secret_handshake.{CloseYourEyes, DoubleBlink, Jump, Wink}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn all_possible_actions_test() {
  secret_handshake.commands(15)
  |> should.equal([Wink, DoubleBlink, CloseYourEyes, Jump])
}

pub fn reverse_all_possible_actions_test() {
  secret_handshake.commands(31)
  |> should.equal([Jump, CloseYourEyes, DoubleBlink, Wink])
}

pub fn third_test() {
  secret_handshake.commands(24)
  |> should.equal([Jump])
}
