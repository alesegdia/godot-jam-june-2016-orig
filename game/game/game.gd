
extends Spatial

onready var cam = get_node("Camera")
onready var infiniteTrack = get_node("InfiniteTrack")

func _ready():
	set_process(true)
	pass

var prev_fov = 0

func _process(delta):
	var new_fov = 60
	if new_fov != prev_fov:
		# cam.set_perspective( new_fov, cam.get_zfar(), cam.get_znear() )
		prev_fov = new_fov
	pass
