
extends ImmediateGeometry

export var height = 3
export var width = 10
export var quad_extent = 0.5

func _ready():
	set_process(true)
	pass

func _process(delta):
	begin(VisualServer.PRIMITIVE_LINES, get_material_override())
	for x in range(width):
		for y in range(height):
			var xx = x * quad_extent
			var yy = y * quad_extent
			var v00 = Vector3( xx - width * quad_extent/2, 0, yy )
			var v10 = Vector3( xx + quad_extent - width * quad_extent /2, 0, yy )
			var v01 = Vector3( xx - width * quad_extent /2, 0, yy + quad_extent )
			var v11 = Vector3( xx + quad_extent - width * quad_extent/2, 0, yy + quad_extent )
			add_vertex(v00)
			add_vertex(v10)
			
			add_vertex(v10)
			add_vertex(v11)
			
			add_vertex(v00)
			add_vertex(v01)
			
			add_vertex(v01)
			add_vertex(v11)
	end()
	pass