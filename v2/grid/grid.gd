extends TileMap

enum CELL_TYPES { EMPTY = -1, ACTOR, IG, DIAMOND, OBJECT, GOLD, METEORITE, URANIUM, BEDROCK}

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


func generate_map(): 
	for i in range(1, grid_size.x):
		for j in range(10, grid_size.y):
			var prob = gaussian(100, 100)
			if prob < 250 && prob > -50:
				set_cell(i, j, get_object_type(prob, j))

func get_object_type(probability, depth):
	var prob = ((probability + 50) / 300.0) * 100
	return switch_object_type(prob, depth + 80)
	
func switch_object_type(starting_threshold, normalized_prob):
	var offset = starting_threshold - 80
	
	var dirt_prec = recalc_probability(offset, 80, 0)
	var gold_prec = recalc_probability(offset, 8, dirt_prec)
	var diamond_prec = recalc_probability(offset, 4, gold_prec)
	var meteo_prec = recalc_probability(offset, 3, diamond_prec)
	var ur_prec = recalc_probability(offset, 2, meteo_prec)
	var bed_prec = recalc_probability(offset, 3, ur_prec)
	
	if normalized_prob < dirt_prec:
		return OBJECT
	elif normalized_prob < gold_prec: # starting at 8%
		return GOLD
	elif normalized_prob < diamond_prec: # starting at 4%
		return DIAMOND
	elif normalized_prob < meteo_prec: # starting at 3%
		return METEORITE
	elif normalized_prob < ur_prec: # starting at 2%
		return URANIUM
	elif normalized_prob < bed_prec: # starting at 3% of bad luck
		return BEDROCK
	else:
		return OBJECT # hack  

func recalc_probability(offset, percentage, previous_value):
	return previous_value - offset + percentage

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

func request_move(pawn, direction, gravity):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	
	match cell_target_type:
		DIAMOND, OBJECT, GOLD, METEORITE, URANIUM:
			var under_cell_position = world_to_map(pawn.position)
			under_cell_position.y = under_cell_position.y + 1
			var under_cell_type = get_cellv(under_cell_position)
			if !gravity && direction.y != -1 && under_cell_type != EMPTY:
				pawn.set_steady(false)
				return [cell_start, cell_target, cell_target_type]
			else:
				pawn.set_steady(true)

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target) + cell_size / 2
