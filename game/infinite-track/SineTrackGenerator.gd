extends "SamplerTrackGenerator.gd"

var slope
var amp
var angle_factor

func _init(amp, angle_factor, zoffset, width).(zoffset, width):
	self.amp = amp
	self.angle_factor = angle_factor
	pass

func f(z):
	return self.amp * sin(z * self.angle_factor) + 5

func row_completed(z):
	pass