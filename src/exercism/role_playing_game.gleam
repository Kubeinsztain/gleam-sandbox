import gleam/int.{max}
import gleam/option.{type Option, None, Some}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(name) -> name
    None -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player.health, player.level {
    hp, level if hp <= 0 && level >= 10 ->
      Some(Player(..player, health: 100, mana: Some(100)))
    hp, _ if hp <= 0 -> Some(Player(..player, health: 100))
    _, _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    Some(mana) ->
      case mana {
        m if m < cost -> #(player, 0)
        _ -> #(Player(..player, mana: Some(mana - cost)), cost * 2)
      }
    _ -> #(Player(..player, health: max(player.health - cost, 0)), 0)
  }
}
