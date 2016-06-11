
extends Spatial

export var height = 20
export var width = 10
export var quad_extent = 0.5

export var line_color = Color( 0.675, 0.169, 0.392 )

var ig
var timer = 0
var y_offset = 0

func _ready():
	ig = get_node("ImmediateGeometry")
	set_process(true)
	pass

func renderTrack( delta ):
	ig.clear()
	ig.begin(VisualServer.PRIMITIVE_LINES, ig.get_material_override())
	ig.set_uv(Vector2(0, 0))
	ig.set_color(line_color)
	for x in range(width):
		for y in range(height):
			var xx = x * quad_extent
			var yy = y * quad_extent + timer
			var v00 = Vector3( xx - width * quad_extent/2, 0, yy )
			var v10 = Vector3( xx + quad_extent - width * quad_extent /2, 0, yy )
			var v01 = Vector3( xx - width * quad_extent /2, 0, yy + quad_extent )
			var v11 = Vector3( xx + quad_extent - width * quad_extent/2, 0, yy + quad_extent )
			ig.add_vertex(v00)
			ig.add_vertex(v10)
			
			ig.add_vertex(v10)
			ig.add_vertex(v11)
			
			ig.add_vertex(v00)
			ig.add_vertex(v01)
			
			ig.add_vertex(v01)
			ig.add_vertex(v11)
	ig.end()
	pass

func _process( delta ):
	timer += delta
	if timer > quad_extent:
		timer = 0
	renderTrack( delta )
	pass