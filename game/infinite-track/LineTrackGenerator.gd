extends "TrackGenerator.gd"

var slope
var line_start

func _init(plinestart, pslope, pzoffset, args).(args):
	slope = pslope
	line_start = plinestart
	z_current = pzoffset

func f(z):
	return z * slope

func plot(x, val):
	next_row[x] = val

func sample(z0, y1, inc):
	for z in range(z0, z1, inc):
		plot(f(z), 1)

func ssample():
	pass

func gen_next_row():
	next_row = Array()
	for i in range(width):
		var rnd = randf()
		if rnd > 0.5:
			next_row.push_back(1)
		else:
			next_row.push_back(0)
