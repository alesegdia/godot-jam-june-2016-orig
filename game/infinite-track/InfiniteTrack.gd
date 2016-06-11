
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

func _ready():
	ig = get_node("ImmediateGeometry")
	set_process(true)
	pass

func renderTrack( delta ):
	ig.clear()
	ig.begin(VisualServer.PRIMITIVE_LINES, ig.get_material_override())
	ig.set_uv(Vector2(0, 0))
	ig.set_color(line_color)
	
	for x in range(width + 1):
		var xx = x * quad_extent - width / 2 * quad_extent
		ig.add_vertex( Vector3( xx, 0, 0 ) )
		ig.add_vertex( Vector3( xx, 0, timer ) )
	
	for x in range(width):
		for y in range(height):
			var cell_value = map.get( x, y )
			if cell_value == 0:
				ig.set_color(line_color)
			else:
				ig.set_color(horizon_color)
			var xx = x * quad_extent
			var yy = y * quad_extent + timer
			var v00 = Vector3( xx - width * quad_extent / 2, 0, yy )
			var v01 = Vector3( xx - width * quad_extent / 2, 0, yy + quad_extent )
			var v10 = Vector3( xx + quad_extent - width * quad_extent / 2, 0, yy )
			var v11 = Vector3( xx + quad_extent - width * quad_extent / 2, 0, yy + quad_extent )
			ig.add_vertex(v00)
			ig.add_vertex(v10)
			
			ig.add_vertex(v10)
			ig.add_vertex(v11)
			
			ig.add_vertex(v00)
			ig.add_vertex(v01)
			
			ig.add_vertex(v01)
			ig.add_vertex(v11)

	ig.set_color( horizon_color )
	ig.add_vertex( Vector3( -10, 0, 0 ) )
	ig.add_vertex( Vector3( 10, 0, 0 ) )
	ig.end()
	pass

func _process( delta ):
	timer += delta
	if timer > quad_extent:
		timer = 0
		row_down()
	renderTrack( delta )
	pass

func row_down():
	map.drop_last_row()
	var row = Array()
	for i in range(width):
		var rnd = randf()
		if rnd > 0.5:
			row.push_back(1)
		else:
			row.push_back(0)
	map.push_row( row )