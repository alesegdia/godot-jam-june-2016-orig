extends "TrackGenerator.gd"

var slope
var line_start

func _init(plinestart, pslope, args).(args):
	slope = pslope
	line_start = plinestart
	pass

func f(y):
	return y * slope

func plot(x, val):
	next_row[x] = val

func sample(x0, x1, inc):
	for x in range(x0, x1, inc):
		plot(f(x), 1)

func gen_next_row():
	next_row = Array()
	for i in range(width):
		var rnd = randf()
		if rnd > 0.5:
			next_row.push_back(1)
		else:
			next_row.push_back(0)
