extends "SamplerTrackGenerator.gd"

var slope
var dir = 1
var offset_flop = 0

func _init(slope, zoffset, width).(zoffset, width):
	self.slope = slope


func flop():
	self.dir *= -1
	self.offset_flop = f(self.z_current) - self.width / 2
	self.z_current = 0
	self.slope *= -1

func f(z):
	var x = z / self.slope + self.offset_flop + self.width / 2
	return x

func row_completed(z):
	if (f(z) < 0 and dir == -1) or (f(z) > width and dir == 1):
		flop()
	if randf() > 0.96:
		flop()
	pass