extends KinematicBody2D
class_name Player

onready var player_sprite = get_node("Texture")
onready var wall_ray = get_node("WallRay")

var velocity: Vector2

var direction: int = 1
var jumpCounter: int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crounching: bool = false

var can_track_input: bool = true
var not_on_wall: bool = true

export(int) var speed

export(int) var player_gravity 
export(int) var wall_gravity

export(int) var jump_speed 
export(int) var wall_jump_speed
export(int) var wall_inpulse_speed   

func _physics_process(_delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()

	gravity(_delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	player_sprite.animate(velocity)


func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("right") - Input.get_action_strength("left")

	if can_track_input == false or attacking:
		velocity.x = 0
		return

	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():
		jumpCounter = 0

	var jump_condition: bool = can_track_input and not attacking

	if Input.is_action_just_pressed("jump") and jumpCounter < 2 and jump_condition:
	   jumpCounter += 1
	   if next_to_wall() and not is_on_floor():
		   velocity.y = wall_jump_speed
		   velocity.x += wall_inpulse_speed * direction
	   else:
		   velocity.y = jump_speed

func actions_env() -> void:
	attack()
	defense()
	crouch()

func attack() -> void:
	var attack_condition: bool = not attacking and not crounching and not defending
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true

func defense() -> void:
	if Input.is_action_pressed("defend") and is_on_floor() and not crounching:
		defending = true
		can_track_input = false
	elif not crounching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true

func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crounching = true
		can_track_input = false
	elif not defending:
		crounching = false
		can_track_input = true
		player_sprite.crouch_off = true

func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
	else:
		velocity.y += player_gravity * delta
		if velocity.y >= player_gravity:
			velocity.y = player_gravity

func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
		return true
	else:
		not_on_wall = true
		return false
