extends "SamplerTrackGenerator.gd"

var slope

func _init(slope, zoffset, width).(zoffset, width):
	self.slope = slope

func f(z):
	return z * 1 / self.slope
