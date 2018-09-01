extends TileMap

enum CELL_TYPES { EMPTY = -1, ACTOR, BEDROCK, OBJECT, OBSTACLE}

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2(30, 50)
var blocks = []


func _ready():
	for i in range(grid_size.y):
		set_cell(0, i, BEDROCK)
		
	for i in range(grid_size.y):
		set_cell(grid_size.x, i, BEDROCK)
	
	for i in range(grid_size.x):
		set_cell(i, 0, BEDROCK)
	
	for i in range(grid_size.x + 1):
		set_cell(i, grid_size.y, BEDROCK)
	
	generate_map()
	
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
	


func generate_map(): 
	for i in range(1, grid_size.x - 1):
		for j in range(10, grid_size.y - 1):
			var prob = gaussian(10, 10)
			if prob < 19 && prob > 1:
				set_cell(i, j, OBJECT)


func gaussian(mean, deviation):
	var x1 = null
	var x2 = null
	var w = null
	
	randomize()
	
	while true:
		x1 = rand_range(0, 2) - 1
		x2 = rand_range(0, 2) - 1
		w = x1*x1 + x2*x2

		if 0 < w && w < 1:
 			break
	w = sqrt(-2 * log(w)/w)
	return floor(mean + deviation * x1 * w)

func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY:
			return update_pawn_position(pawn, cell_start, cell_target)
		OBJECT:
			var object_pawn = get_cell_pawn(cell_target)
			object_pawn.queue_free()
			return update_pawn_position(pawn, cell_start, cell_target)
		ACTOR:
			var pawn_name = get_cell_pawn(cell_target).name
			print("Cell %s contains %s" % [cell_target, pawn_name])


func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target) + cell_size / 2
