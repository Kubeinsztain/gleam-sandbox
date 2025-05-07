import gleam/dict
import gleam/dynamic/decode.{type Dynamic}
import gleam/option.{type Option, None}

pub type VillagerType {
  Warrior
  Smith
  Priest
  Farmer
  Librarian
}

pub type Npc {
  Villager(
    name: String,
    location: #(Int, Int),
    speciality: VillagerType,
    reward_xp: Option(Int),
  )
}

pub fn first_example(data: Dynamic) {
  let villager_type_decoder = {
    use villager_type_string <- decode.then(decode.string)
    case villager_type_string {
      "warrior" -> decode.success(Warrior)
      "smith" -> decode.success(Smith)
      "priest" -> decode.success(Priest)
      "farmer" -> decode.success(Farmer)
      "librarian" -> decode.success(Librarian)
      _ -> decode.failure(Warrior, "VillagerType")
    }
  }

  let location_decoder = {
    use location_dict <- decode.then(decode.dict(decode.string, decode.int))
    case dict.get(location_dict, "x"), dict.get(location_dict, "y") {
      Ok(x), Ok(y) -> decode.success(#(x, y))
      _, _ -> decode.failure(#(0, 0), "Location")
    }
  }

  let villager_decoder = {
    use name <- decode.field("name", decode.string)
    use location <- decode.field("location", location_decoder)
    use speciality <- decode.field("speciality", villager_type_decoder)
    use reward_xp <- decode.optional_field(
      "reward_xp",
      None,
      decode.optional(decode.int),
    )

    decode.success(Villager(name:, location:, speciality:, reward_xp:))
  }

  decode.run(data, villager_decoder)
}
