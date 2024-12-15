extends ParallaxBackground
class_name Background

# Declare member variables here
export(bool) var can_process
export(Array, int) var layer_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	if can_process == false:
		set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	for index in get_child_count() :
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= _delta * layer_speed[index]
			