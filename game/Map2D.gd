
var map = Array()
var width
var height

func _init( pwidth, pheight ):
	width = pwidth
	height = pheight
	for y in range(height):
		var row = Array()
		for x in range(width):
			row.insert( x, 0 )
		map.insert( y, row )

func get( x, y ):
	return map[y][x]

func set( x, y, val ):
	map[y][x] = val

func drop_last_row():
	map.remove( map.size() - 1 )

func push_row( row ):
	map.insert( 0, row )