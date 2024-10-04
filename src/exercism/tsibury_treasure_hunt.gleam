import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  #(place_location.1, place_location.0)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  let #(place_location_id, place_location_name) = place_location
  let #(treasure_location_name, treasure_location_id) = treasure_location

  place_location_id == treasure_location_id
  && place_location_name == treasure_location_name
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  list.filter(treasures, fn(treasure) {
    treasure_location_matches_place_location(place.1, treasure.1)
  })
  |> list.length
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  // Treasure Name, Possible swap treasure names, Possible swap place names
  let rules: List(#(String, List(String), List(String))) = [
    #("Brass Spyglass", [], ["Abandoned Lighthouse"]),
    #("Amethyst Octopus", ["Crystal Crab", "Glass Starfish"], [
      "Stormy Breakwater",
    ]),
    #(
      "Vintage Pirate Hat",
      ["Model Ship in Large Bottle", "Antique Glass Fishnet Float"],
      ["Harbor Managers Office"],
    ),
  ]

  list.any(rules, fn(rule) {
    let #(treasure_name, swap_treasure_names, swap_place_names) = rule

    treasure_name == found_treasure.0
    && {
      swap_treasure_names |> list.length == 0
      || {
        list.any(swap_treasure_names, fn(swap_treasure_name) {
          swap_treasure_name == desired_treasure.0
        })
      }
    }
    && {
      swap_place_names |> list.length == 0
      || {
        list.any(swap_place_names, fn(swap_place_name) {
          swap_place_name == place.0
        })
      }
    }
  })
}
