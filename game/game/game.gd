
extends Spatial

onready var cam = get_node("Camera")
onready var infiniteTrack = get_node("InfiniteTrack")
onready var player = get_node("Player")

func _ready():
	set_process(true)
	pass

var prev_fov = 0

func handleFov():
	var new_fov = 60 * log(infiniteTrack.base_speed) / 1.5
	if new_fov != prev_fov:
		
		# set new fov
		cam.set_perspective( new_fov, cam.get_znear(), cam.get_zfar() )
		prev_fov = new_fov
		
		# retreat player to avoid going too far
		var xform = player.get_transform()
		xform.origin.z = player.base_z + log(infiniteTrack.base_speed) / 2.4
		player.set_transform(xform)

func detectPlayerTile():
	var px = player.get_transform().origin.x
	var pz = player.get_transform().origin.z
	var tile = infiniteTrack.getTile( px, pz )
	if tile == 0:
		infiniteTrack.decreaseAccel()
	elif tile == 1:
		infiniteTrack.increaseAccel()
	pass
	var tiles = infiniteTrack.getTiles( px, pz, 1.5, 1.5 )
	print(tiles.size())

func _process(delta):
	handleFov()
	detectPlayerTile()
	var px = player.get_transform().origin.x
	var pz = player.get_transform().origin.z
	infiniteTrack.set_player_area( px, pz, 1.0, 1.0 )
	pass
