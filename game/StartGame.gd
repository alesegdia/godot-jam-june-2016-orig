
extends Control

onready var space_to_start = get_node("SpaceToStart")
onready var razor_x = get_node("RazorX")

export var blink_timer = 2.0

func _ready():
	set_process(true)
	pass

var timer = 0

func set_show( sts, rx ):
	if sts:
		space_to_start.show()
	else:
		space_to_start.hide()
	
	if rx:
		razor_x.show()
	else:
		razor_x.hide()

func _process(delta):
	timer += delta
	if timer < blink_timer:
		set_show(true, false)
	elif timer < blink_timer * 2:
		set_show(false, false)
	elif timer < blink_timer * 3:
		set_show(false, true)
	elif timer < blink_timer * 4:
		set_show(false, false)
	else:
		timer = 0