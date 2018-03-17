extends RigidBody2D

var MOVE_SPEED = 1000;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _process(delta):
	var which = get_name()
	# move up and down based on input
	if Input.is_action_pressed(which+"_move_up") and position.y > 0:
		position.y -= MOVE_SPEED * delta
	if Input.is_action_pressed(which+"_move_down") and position.y < get_viewport_rect().size.y:
		position.y += MOVE_SPEED * delta
	if Input.is_action_pressed(which+"_move_left") and position.x > 0:
		position.x -= MOVE_SPEED * delta
	if Input.is_action_pressed(which+"_move_right") and position.x < get_viewport_rect().size.x:
		position.x += MOVE_SPEED * delta
	