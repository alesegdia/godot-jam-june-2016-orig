
extends MeshInstance

# member variables here, example:
# var a=2
# var b="textvar"

func make_plane( width, height ):
	indices = Array()
	for x in range(width):
		for y in range(height):
			indices.append( Vector3( x, y, 0 ) )
	pass

func _ready():
	mesh = Mesh()
	pass


