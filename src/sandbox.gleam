import exercism/expert_experiments
import gleam/io

pub fn main() {
  use setup_data, action_data <- expert_experiments.run_experiment(
    "Test 1",
    setup,
    action,
  )

  setup_data |> io.debug
  action_data |> io.debug

  Ok("Success")
}

fn setup() -> Result(Int, String) {
  // Ok(3)
  Error("Failed to setup")
}

fn action(data: Int) -> Result(Int, String) {
  Ok(data + 5)
}
