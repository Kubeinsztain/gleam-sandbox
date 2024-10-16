pub type Planet {
  Mercury
  Venus
  Earth
  Mars
  Jupiter
  Saturn
  Uranus
  Neptune
}

pub fn age(planet: Planet, seconds: Float) -> Float {
  let earth_years = seconds /. 60.0 /. 60.0 /. 24.0 /. 365.25
  case planet {
    Mercury -> earth_years /. 0.2408467
    Venus -> earth_years /. 0.61519726
    Earth -> earth_years
    Mars -> earth_years /. 1.8808158
    Jupiter -> earth_years /. 11.862615
    Saturn -> earth_years /. 29.447498
    Uranus -> earth_years /. 84.016846
    Neptune -> earth_years /. 164.79132
  }
}
