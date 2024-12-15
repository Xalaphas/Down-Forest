extends KinematicBody2D
class_name Player

onready var player_sprite = get_node("Texture")

var velocity: Vector2


export(int) var speed

func _physics_process(_delta: float):
    horizontal_movement_env()
    velocity = move_and_slide(velocity)
    player_sprite.animate(velocity)


func horizontal_movement_env() -> void:
    var input_direction: float = Input.get_action_strength("right") - Input.get_action_strength("left")
    velocity.x = input_direction * speed
    