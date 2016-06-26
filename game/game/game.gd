
extends Spatial

var Map2D = load("Map2D.gd")

onready var startgame = get_node("StartGame")
onready var counters_gui = get_node("CountersGUI")
onready var cam = get_node("Camera")
onready var infiniteTrack = get_node("InfiniteTrack")
onready var player = get_node("Player")
onready var distance_counter = counters_gui.get_node("DistanceCounter")
onready var speed_counter = counters_gui.get_node("SpeedCounter")
onready var countdown_counter = counters_gui.get_node("CountdownCounter")
onready var race_director = get_node("RaceDirector")
onready var hiscore_lbl = startgame.get_node("HiScoreLabel")
onready var currentscore_lbl = startgame.get_node("CurrentScoreLabel")

export var multi_tile_check = true
export var countdown_timer_value = 60.0

var countdown = countdown_timer_value

func _ready():
	set_process(true)
	set_process_input(true)
	race_director.add_generator(load("res://infinite-track/SineTrackGenerator.gd").new( 4, 0.1, 0.5, infiniteTrack.width ), 10.0)
	race_director.add_generator(load("res://infinite-track/AllTrackGenerator.gd").new( infiniteTrack.width ), 2.0)
	
	race_director.add_generator(load("res://infinite-track/LineTrackGenerator.gd").new( 5.0, 0.5, infiniteTrack.width ), 10.0)
	race_director.add_generator(load("res://infinite-track/AllTrackGenerator.gd").new( infiniteTrack.width ), 2.0)
	
	race_director.add_generator(load("res://infinite-track/LineTrackGenerator.gd").new( 10.0, 0.5, infiniteTrack.width ), 10.0)
	race_director.add_generator(load("res://infinite-track/AllTrackGenerator.gd").new( infiniteTrack.width ), 2.0)
	
	race_director.add_generator(load("res://infinite-track/SineTrackGenerator.gd").new( 2, 0.1, 0.5, infiniteTrack.width ), 10.0)
	race_director.add_generator(load("res://infinite-track/AllTrackGenerator.gd").new( infiniteTrack.width ), 2.0)
	
	race_director.add_generator(load("res://infinite-track/LineTrackGenerator.gd").new( 10.0, 0.5, infiniteTrack.width ), 10.0)
	race_director.add_generator(load("res://infinite-track/AllTrackGenerator.gd").new( infiniteTrack.width ), 2.0)
	
	race_director.set_track(infiniteTrack)
	infiniteTrack.set_generator(race_director.get_generator())
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
		var tiles = infiniteTrack.getTiles( px, pz, 0.5, 0.5 )
		var did_find = false
		for t in range(tiles.size()):
			if tiles[t] == 1:
				did_find = true
				infiniteTrack.increaseAccel()
				break
		if not did_find:
			infiniteTrack.decreaseAccel()
		## Accumulative
		#if tile == 0:
		#	infiniteTrack.decreaseAccel()
		#elif tile == 1:
		#	infiniteTrack.increaseAccel()

var race_running = false

func _process(delta):
	distance_counter.set_text(str(infiniteTrack.distance))
	speed_counter.set_text(str(floor(infiniteTrack.base_speed * 10)))
	
	countdown -= delta
	countdown_counter.set_text(str(floor(countdown)))
	
	handleFov()
	if race_running:
		detectPlayerTile()
	var px = player.get_transform().origin.x
	var pz = player.get_transform().origin.z
	infiniteTrack.set_player_area( px, pz )
	
	if not race_running and Input.is_action_pressed("ui_accept"):
		start_game()
	
	if race_running and countdown <= 0:
		stop_game()

var hiscore = 0
var currentscore = 0

func start_game():
	race_running = true
	player.can_move = true
	counters_gui.show()
	startgame.hide()
	countdown = countdown_timer_value
	infiniteTrack.running = true
	infiniteTrack.distance = 0
	infiniteTrack.base_speed = 4.2
	infiniteTrack.clear()
	var xform = player.get_transform()
	xform.origin.x = 0
	player.set_transform(xform)

func stop_game():
	race_running = false
	player.can_move = false
	infiniteTrack.running = false
	counters_gui.hide()
	startgame.show()
	currentscore = infiniteTrack.distance
	if currentscore > hiscore:
		hiscore = currentscore
	currentscore_lbl.set_text(str(currentscore))
	hiscore_lbl.set_text(str(hiscore))
	