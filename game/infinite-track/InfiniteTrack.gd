
extends Spatial

export var height = 20
export var width = 10
export var quad_extent = 0.5

export var line_color = Color( 0.675, 0.169, 0.392 )
export var horizon_color = Color( 0.675, 0.169, 0.392 )

export var increase_speed_rate = 0.1
export var decrease_speed_rate = 0.1

var ig
var timer = 0
var y_offset = 0

var Map2D = load("Map2D.gd")
var map = Map2D.new( width, height )
var next_row
var row_generator
export var speed_range = Vector2( 4.255, 10000.0 )
export var ship_width = 1.5
export var ship_height = 1.5
export var manual_speed = false


export var base_speed = 1.0

func _ready():
#	row_generator = load("res://infinite-track/RandomTrackGenerator.gd").new( width )
#	row_generator = load("res://infinite-track/LineTrackGenerator.gd").new( 10.0, 0.5, width )
	row_generator = load("res://infinite-track/SineTrackGenerator.gd").new( 1.5, 0.2, 0.5, width )

	ig = get_node("ImmediateGeometry")
	gen_row()
	set_process(true)
	set_process_input(true)
	pass

func gen_row():
	row_generator.gen_next_row()
	next_row = row_generator.next_row

func renderQuads( delta, num, color ):
	ig.begin(VisualServer.PRIMITIVE_LINES, ig.get_material_override())
	ig.set_uv(Vector2(0, 0))
	ig.set_color(color)
	
	for x in range(width):
		var cell_value = next_row[x]
		if cell_value == num:
			var xx = x * quad_extent - width / 2 * quad_extent
			ig.add_vertex( Vector3( xx, 0, 0 ) )
			ig.add_vertex( Vector3( xx, 0, timer * base_speed ) )
			ig.add_vertex( Vector3( xx + quad_extent, 0, 0 ) )
			ig.add_vertex( Vector3( xx + quad_extent, 0, timer * base_speed ) )
	
	for x in range(width):
		for y in range(height):
			var cell_value = map.get( x, y )
			if cell_value == num:
				var xx = x * quad_extent
				var yy = y * quad_extent + timer * base_speed
				var left = xx - width * quad_extent / 2
				var right = xx + quad_extent - width * quad_extent / 2
				var up = yy
				var down = yy + quad_extent
				var v00 = Vector3( left, 0, up )
				var v01 = Vector3( left, 0, down )
				var v10 = Vector3( right, 0, up )
				var v11 = Vector3( right, 0, down )
				ig.add_vertex(v00)
				ig.add_vertex(v10)
				
				ig.add_vertex(v10)
				ig.add_vertex(v11)
				
				ig.add_vertex(v00)
				ig.add_vertex(v01)
				
				ig.add_vertex(v01)
				ig.add_vertex(v11)
				
				if num == 1:
					var mic = quad_extent / 8
					
					# Left upper corner
					ig.add_vertex( Vector3( left + mic, 0, up + mic ) )
					ig.add_vertex( Vector3( left + mic * 2, 0, up + mic ) )
					
					ig.add_vertex( Vector3( left + mic, 0, up + mic ) )
					ig.add_vertex( Vector3( left + mic, 0, up + mic * 2 ) )
					
					# Left bottom corner
					ig.add_vertex( Vector3( left + mic, 0, down - mic ) )
					ig.add_vertex( Vector3( left + mic * 2, 0, down - mic ) )
					
					ig.add_vertex( Vector3( left + mic, 0, down - mic ) )
					ig.add_vertex( Vector3( left + mic, 0, down - mic * 2 ) )
					
					# Right upper corner
					ig.add_vertex( Vector3( right - mic, 0, up + mic ) )
					ig.add_vertex( Vector3( right - mic * 2, 0, up + mic ) )
					
					ig.add_vertex( Vector3( right - mic, 0, up + mic ) )
					ig.add_vertex( Vector3( right - mic, 0, up + mic * 2 ) )
					
					# Right bottom corner
					ig.add_vertex( Vector3( right - mic, 0, down - mic ) )
					ig.add_vertex( Vector3( right - mic * 2, 0, down - mic ) )
					
					ig.add_vertex( Vector3( right - mic, 0, down - mic ) )
					ig.add_vertex( Vector3( right - mic, 0, down - mic * 2 ) )
					
	ig.set_color( horizon_color )
	ig.add_vertex( Vector3( -1000, 0, 0 ) )
	ig.add_vertex( Vector3( 1000, 0, 0 ) )
	ig.end()
	pass

var px
var py
var pw
var ph

func set_player_area( x, y ):
	px = x
	py = y

func draw_player_area():
	var l = px - ship_width / 2
	var r = px + ship_width / 2
	var u = py - ship_height / 2
	var b = py + ship_height / 2
	
	ig.begin(VisualServer.PRIMITIVE_LINES, ig.get_material_override())
	ig.set_color( Color( 0.8, 0.6, 0.2 ) )
	ig.add_vertex( Vector3( l, 0, u ) )
	ig.add_vertex( Vector3( r, 0, u ) )
	ig.add_vertex( Vector3( l, 0, u ) )
	ig.add_vertex( Vector3( l, 0, b ) )
	
	ig.add_vertex( Vector3( r, 0, b ) )
	ig.add_vertex( Vector3( r, 0, u ) )
	ig.add_vertex( Vector3( r, 0, b ) )
	ig.add_vertex( Vector3( l, 0, b ) )
	ig.end()



func getTile( x, z ):
	x += quad_extent * width / 2
	var tx = x / quad_extent
	var tz = z / quad_extent
	if tx < 0 || tx >= width:
		tx = -1
	if tz < 0 || tz >= width:
		tz = -1
	var tile = Vector2( floor(tx), floor(tz) )
	var tile_val = -1
	if tile.x >= 0 && tile.y >= 0 && tile.x < width && tile.y < height:
		tile_val = map.get( tile.x, tile.y )
	return tile_val

func getTiles( cx, cy, w, h ):
	var tiles = Array()
	var w2 = w / 2
	var h2 = h / 2
	var tl = floor( ( cx - w2 ) / quad_extent + width / 2 )
	var tr = floor( ( cx + w2 ) / quad_extent + width / 2 )
	var tu = floor( ( cy + h2 ) / quad_extent )
	var tb = floor( ( cy - h2 ) / quad_extent )
	for x in range( tl, tr + 1, 1 ):
		for y in range( tb, tu + 1, 1 ):
			if x >= 0 && x < width && y >= 0 && y < height:
				var tile = map.get( x, y )
				tiles.append( tile )
	return tiles

func increaseAccel():
	setSpeed( base_speed + increase_speed_rate )
	pass

func decreaseAccel():
	setSpeed( base_speed - decrease_speed_rate )
	pass

func setSpeed( new_speed ):
	base_speed = new_speed
	base_speed = clamp( base_speed, speed_range.x, speed_range.y )
	pass

func _process( delta ):
	timer += delta
	while timer * base_speed > quad_extent:
		timer -= quad_extent / base_speed
		row_down()
	ig.clear()
	renderQuads( delta, 0, line_color )
	renderQuads( delta, 1, horizon_color )
	draw_player_area()
	
	if manual_speed:
		if Input.is_action_pressed("ui_up"):
			base_speed += 0.1
		elif Input.is_action_pressed("ui_down"):
			base_speed -= 0.1

func row_down():
	map.drop_last_row()
	map.push_row( next_row )
	gen_row()