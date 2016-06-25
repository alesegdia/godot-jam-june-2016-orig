extends "TrackGenerator.gd"

var line_start
var z_current

func _init(pzoffset, args).(args):
	z_current = pzoffset

func f(z):
	return 0

func plot(x, val):
	if x >= 0 and x < width:
		next_row[x] = val

func sample(z0, z1, resolution):
	assert(z1 > z0)
	var step = (z1 - z0) / resolution
	for i in range(0, resolution):
		var z = z0 + i * step
		plot(f(z), 1)

func advance(quantity, resolution):
	sample(z_current, z_current + quantity, resolution)
	z_current = z_current + quantity
	pass

func gen_next_row():
	regen_next_row()
	advance(1.0, 100.0)

