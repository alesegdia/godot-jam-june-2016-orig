
extends Spatial

onready var cam = get_node("Camera")
onready var infiniteTrack = get_node("InfiniteTrack")
onready var player = get_node("Player")

func _ready():
	set_process(true)
	pass

var prev_fov = 0

func _process(delta):
	var new_fov = 60 * log(infiniteTrack.base_speed) / 1.5
	if new_fov != prev_fov:
		cam.set_perspective( new_fov, cam.get_znear(), cam.get_zfar() )
		prev_fov = new_fov
		
		var xform = player.get_transform()
		xform.origin.z = player.base_z + log(infiniteTrack.base_speed) / 2.4
		player.set_transform(xform)
	pass
