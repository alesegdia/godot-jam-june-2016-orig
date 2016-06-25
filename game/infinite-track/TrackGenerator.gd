
extends Reference

var width
var next_row

func _init( pwidth ):
	width = pwidth
	pass

func _ready():
	pass

func regen_next_row():
	next_row = Array()
	for i in range(0, width):
		next_row.push_back(0)

func gen_next_row():
	pass
