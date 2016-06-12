
extends "TrackGenerator.gd"

func _init(args).(args):
	pass

func gen_next_row():
	next_row = Array()
	for i in range(width):
		var rnd = randf()
		if rnd > 0.5:
			next_row.push_back(1)
		else:
			next_row.push_back(0)
