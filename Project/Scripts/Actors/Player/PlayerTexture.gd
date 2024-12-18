extends Sprite
class_name PlayerTexture

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D 

var normal_attack: bool = false
var suffix: String = "Right"
var shield_off: bool = false
var crouch_off: bool = false

func animate(direction: Vector2) -> void:
	verify_position(direction)

	if player.attacking or player.defending or player.crounching or player.next_to_wall():
		action_behavior()
	elif direction.y != 0:
		vertical_behavior(direction)
	elif player.landing == true:
		animation.play("Landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)


func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		suffix = "Right"
		player.direction = -1
		position = Vector2.ZERO
		player.wall_ray.cast_to = Vector2(5.5, 0)
	elif direction.x < 0:
		flip_h = true
		suffix = "Left"
		player.direction = 1
		position = Vector2(-2, 0)
		player.wall_ray.cast_to = Vector2(-7.5, 0)

func action_behavior() -> void:
	if player.next_to_wall():
		animation.play("WallSlide")
	elif player.attacking and normal_attack:
		animation.play("Attack" + suffix)
	elif player.defending and shield_off:
		animation.play("Shield")
		shield_off = false
	elif player.crounching and crouch_off:
		animation.play("Crouch")
		crouch_off= false

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("Fall")
	elif direction.y < 0:
		animation.play("Jump")

func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("Run")
	else:
		animation.play("Idle")


func _on_animation_finished(anim_name: String):
	match anim_name:
		"Landing":
			player.landing = false
			player.set_physics_process(true)

		"AttackRight":
			normal_attack = false
			player.attacking = false

		"AttackLeft":
			normal_attack = false
			player.attacking = false