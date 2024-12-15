extends KinematicBody2D
class_name Player

onready var player_sprite = get_node("Texture")

var velocity: Vector2
var jumpCounter: int = 0

var landing: bool = false


export(int) var speed
export(int) var jump_speed 
export(int) var player_gravity 

func _physics_process(_delta: float):
    horizontal_movement_env()
    vertical_movement_env()

    gravity(_delta)
    velocity = move_and_slide(velocity, Vector2.UP)
    player_sprite.animate(velocity)


func horizontal_movement_env() -> void:
    var input_direction: float = Input.get_action_strength("right") - Input.get_action_strength("left")
    velocity.x = input_direction * speed

func vertical_movement_env() -> void:
    if is_on_floor():
        jumpCounter = 0

    if Input.is_action_just_pressed("jump") and jumpCounter < 2:
       jumpCounter += 1
       velocity.y = jump_speed

func gravity(_delta: float) -> void:
    velocity.y += _delta * player_gravity

    if velocity.y >= player_gravity:
        velocity.y = player_gravity
    