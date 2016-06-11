
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)
	set_process(true)
	pass

func _process(delta):
	var dir = 0
	if Input.is_action_pressed("ui_left"):
		dir = -1
	elif Input.is_action_pressed("ui_right"):
		dir = 1
	var xform = get_transform()
	xform.origin.x += dir * 0.03
	set_transform( xform )
	pass