extends "pawn.gd"

onready var Grid = get_parent()

var steady = false;

func set_steady(new_steady):
	steady = new_steady

func _ready():
	update_look_direction(Vector2(1, 0))

func _process(delta):
	var input_direction = get_input_direction()
	var gravity = false
	if not input_direction:
		input_direction = Vector2(0, 1)
		gravity = true
	update_look_direction(input_direction)

	var request_move_result = Grid.request_move(self, input_direction, gravity);
	if !request_move_result:
		return
	var cell_start = request_move_result[0]
	var cell_target = request_move_result[1]
	var target_cell_type = request_move_result[2]
	if target_cell_type == CELL_TYPES.OBJECT:
		bump(cell_start, cell_target, 4)
	else:
		var target_position = Grid.update_pawn_position(self, cell_start, cell_target)
		move_to(target_position)

func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)


func update_look_direction(direction):
	$Pivot/Sprite.rotation = direction.angle()


func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property($Pivot, "position", - move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	position = target_position
	
	$Tween.start()

	# Stop the function execution until the animation finished
	yield($AnimationPlayer, "animation_finished")
	
	set_process(true)


func bump(cell_start, cell_target, times):
	set_process(false)
	for i in times:
		$AnimationPlayer.play("bump")
		yield( $AnimationPlayer, "animation_finished" )
	set_process(true)
	var target_position = Grid.update_pawn_position(self, cell_start, cell_target)
	move_to(target_position)

