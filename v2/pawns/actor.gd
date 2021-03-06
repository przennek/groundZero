extends "pawn.gd"

onready var Grid = get_parent()

var steady = false;
var started = false;

onready var fuel_bar = get_node("Camera2D/fuel_bar")
onready var actor_sound_effect_player = get_node("PlayerSoundEffectsPlayer")
onready var game_splash_screen = self.get_parent().get_child(0);

func set_steady(new_steady):
	steady = new_steady

func _ready():
	update_look_direction(Vector2(1, 0))
	set_process(false)
	set_visible(false)
	
func _input(event):
	if event is InputEventKey and not started and event.get_scancode() == 16777221:
		if event.pressed:
			set_process(true)
			set_visible(true)
			started = true
			
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
	
	if cell_target.y == 199: # ENDING GAME IF
		get_tree().reload_current_scene()
		game_splash_screen.swap_screen_to_win()

	var fuel_to_be_substracted = 0;
	if target_cell_type == CELL_TYPES.OBJECT:
		bump(cell_start, cell_target, 4)
		fuel_to_be_substracted = 3
	elif target_cell_type == CELL_TYPES.GOLD:
		bump(cell_start, cell_target, 8)
		fuel_bar.add_money(3000)
		fuel_to_be_substracted = 4
	elif target_cell_type == CELL_TYPES.DIAMOND:
		bump(cell_start, cell_target, 12)
		fuel_bar.add_money(8000)
		fuel_to_be_substracted = 8
	elif target_cell_type == CELL_TYPES.METEORITE:
		bump(cell_start, cell_target, 16)
		fuel_bar.add_money(12000)
		fuel_to_be_substracted = 12
	elif target_cell_type == CELL_TYPES.URANIUM:
		bump(cell_start, cell_target, 16)
		fuel_bar.add_money(12000)
		fuel_to_be_substracted = 12
	elif cell_target.y > 46 &&  cell_target.y < 50 && cell_target.x> 31 && cell_target.x < 43:
		var target_position = Grid.update_pawn_position(self, cell_start, cell_target)
		move_to(target_position)
		exchange_money()
	else:
		var target_position = Grid.update_pawn_position(self, cell_start, cell_target)
		move_to(target_position)
		if(!gravity):
			fuel_bar.substract_value(0.1)
	
	fuel_bar.substract_value(fuel_to_be_substracted)
	if get_parent().fuel_bar.current_value <= 0:
		get_tree().reload_current_scene()
		game_splash_screen.swap_screen_to_lose()
	
func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func exchange_money():
	var neededFuel = 100 - fuel_bar.current_value
	var needed_money = neededFuel * 300
	if fuel_bar.money > needed_money:
		fuel_bar.substract_money(needed_money)
		fuel_bar.set_value(100)
	else:
		fuel_bar.add_value(float(fuel_bar.money) / 300)
		fuel_bar.set_money(0)		

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
	actor_sound_effect_player.play_drill_sound_effect()
	set_process(false)
	for i in times:
		$AnimationPlayer.play("bump")
		yield( $AnimationPlayer, "animation_finished" )
	set_process(true)
	var target_position = Grid.update_pawn_position(self, cell_start, cell_target)
	move_to(target_position)

