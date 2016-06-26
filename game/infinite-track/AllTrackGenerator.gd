
extends "TrackGenerator.gd"

func _init(args).(args):
	pass

func gen_next_row():
	next_row = Array()
	for i in range(width):
		next_row.push_back(1)
