
extends Spatial

export var rear_speed = 0.03
export var can_move = false
var base_z

func _ready():
	set_process_input(true)
	set_process(true)
	base_z = get_transform().origin.z
	pass

func _process(delta):
	var dir = 0
	if can_move:
		if Input.is_action_pressed("ui_left"):
			dir = -1
		elif Input.is_action_pressed("ui_right"):
			dir = 1
	var xform = get_transform()
	xform.origin.x += dir * rear_speed
	set_transform( xform )
	pass