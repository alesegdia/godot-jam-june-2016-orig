
extends Spatial

export var height = 20
export var width = 10
export var quad_extent = 0.5

export var line_color = Color( 0.675, 0.169, 0.392 )
export var horizon_color = Color( 0.675, 0.169, 0.392 )

var ig
var timer = 0
var y_offset = 0

var Map2D = load("Map2D.gd")
var map = Map2D.new( width, height )
var next_row
var row_generator

export var base_speed = 1.0

func _ready():
	row_generator = load("/infinite-track/RandomTrackGenerator.gd").new( width )
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
				var v00 = Vector3( left, 0, yy )
				var v01 = Vector3( left, 0, yy + quad_extent )
				var v10 = Vector3( right, 0, yy )
				var v11 = Vector3( right, 0, yy + quad_extent )
				ig.add_vertex(v00)
				ig.add_vertex(v10)
				
				ig.add_vertex(v10)
				ig.add_vertex(v11)
				
				ig.add_vertex(v00)
				ig.add_vertex(v01)
				
				ig.add_vertex(v01)
				ig.add_vertex(v11)

	ig.set_color( horizon_color )
	ig.add_vertex( Vector3( -1000, 0, 0 ) )
	ig.add_vertex( Vector3( 1000, 0, 0 ) )
	ig.end()
	pass

func _process( delta ):
	timer += delta
	while timer * base_speed > quad_extent:
		timer -= quad_extent / base_speed
		row_down()
	ig.clear()
	renderQuads( delta, 0, line_color )
	renderQuads( delta, 1, horizon_color )
	
	if Input.is_action_pressed("ui_up"):
		base_speed += 0.1
	elif Input.is_action_pressed("ui_down"):
		base_speed -= 0.1
	pass

func row_down():
	map.drop_last_row()
	map.push_row( next_row )
	gen_row()