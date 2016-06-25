extends "SamplerTrackGenerator.gd"

var slope

func _init(pslope, zoffset, width).(zoffset, width):
	slope = pslope

func f(z):
	return z * 1 / slope
