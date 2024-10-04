import gleam/float
import gleam/list
import gleam/order.{type Order}

pub type City {
  City(name: String, temperature: Temperature)
}

pub type Temperature {
  Celsius(Float)
  Fahrenheit(Float)
}

pub fn fahrenheit_to_celsius(f: Float) -> Float {
  { f -. 32.0 } /. 1.8
}

pub fn compare_temperature(left: Temperature, right: Temperature) -> Order {
  let celsius_left = case left {
    Celsius(c) -> c
    Fahrenheit(f) -> fahrenheit_to_celsius(f)
  }

  let celsius_right = case right {
    Celsius(c) -> c
    Fahrenheit(f) -> fahrenheit_to_celsius(f)
  }

  float.compare(celsius_left, celsius_right)
}

pub fn sort_cities_by_temperature(cities: List(City)) -> List(City) {
  list.sort(cities, fn(city_one, city_two) {
    compare_temperature(city_one.temperature, city_two.temperature)
  })
}
