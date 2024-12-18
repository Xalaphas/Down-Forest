extends Node
class_name PlayerStats

var shielding: bool = false

var base_health: int = 20
var base_mana: int = 10
var base_attack: int = 2
var base_magic_attack: int = 4
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_magic_attack: int = 0
var bonus_defense: int = 0

var current_health: int
var current_mana: int
var current_exp: int

var max_health: int
var max_mana: int

var level: int = 1
var level_dict: Dictionary = {
    "1": 25,
    "2": 50,
    "3": 75,
    "4": 100,
    "5": 125,
    "6": 150,
    "7": 175,
    "8": 200,
    "9": 225,
    "10": 250
}

func _ready() -> void:
    current_mana = base_mana + bonus_mana
    max_mana = current_mana

    current_health = base_health + bonus_health
    max_health = current_health

func update_exp(value: int) -> void:
    current_exp += value
    if current_exp >= level_dict[str(level)] and level < 10:
        var leftover: int = current_exp - level_dict[str(level)]
        current_exp = leftover
        on_level_up()
        level += 1
    elif current_exp >= level_dict[str(level)] and level == 10:
        current_exp = level_dict[str(level)]

func on_level_up() -> void:
    current_mana = base_mana + bonus_mana
    current_health = base_health + bonus_health