
extends ImmediateGeometry

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	pass

func _process(delta):
	begin(VisualServer.PRIMITIVE_LINES, get_material_override())
	for x in range(10):
		for y in range(5):
			var v00 = Vector3( x - 10/2, 0, y )
			var v10 = Vector3( x+1 - 10/2, 0, y )
			var v01 = Vector3( x - 10/2, 0, y+1 )
			var v11 = Vector3( x+1 - 10/2, 0, y+1 )
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