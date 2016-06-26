
extends Spatial

var generators = Array()
var current_generator = 0
var track

func _ready():
	set_process(true)

func _process(delta):
	assert(not generators.empty())
	generators[current_generator].time -= delta
	if generators[current_generator].time < 0:
		generators[current_generator].time = generators[current_generator].duration
		current_generator = (current_generator + 1) % generators.size()
		self.track.set_generator(generators[current_generator].generator)

func add_generator(generator, time):
	var entry = {}
	entry.generator = generator
	entry.time = time
	entry.duration = time
	generators.append(entry)

func get_generator():
	return generators[0].generator

func set_track(track):
	self.track = track