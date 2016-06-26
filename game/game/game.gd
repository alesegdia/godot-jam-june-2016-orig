
extends Spatial

onready var cam = get_node("Camera")
onready var infiniteTrack = get_node("InfiniteTrack")
onready var player = get_node("Player")
onready var distance_counter = get_node("DistanceCounter")
onready var speed_counter = get_node("SpeedCounter")
onready var countdown_counter = get_node("CountdownCounter")

export var multi_tile_check = true

var countdown = 60.0

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
	
	if multi_tile_check:
		var tiles = infiniteTrack.getTiles( px, pz, 0.5, 0.5 )
		for t in range(tiles.size()):
			if tiles[t] == 1:
				infiniteTrack.increaseAccel()
			elif tiles[t] == 0:
				infiniteTrack.decreaseAccel()
	else:
		if tile == 0:
			infiniteTrack.decreaseAccel()
		elif tile == 1:
			infiniteTrack.increaseAccel()


func _process(delta):
	distance_counter.set_text(str(infiniteTrack.distance))
	speed_counter.set_text(str(floor(infiniteTrack.base_speed * 10)))
	
	countdown -= delta
	countdown_counter.set_text(str(floor(countdown)))
	
	handleFov()
	detectPlayerTile()
	var px = player.get_transform().origin.x
	var pz = player.get_transform().origin.z
	infiniteTrack.set_player_area( px, pz )
	pass
