extends RigidBody2D

var MOVE_SPEED = 1000;
var velocity = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	var which = get_name()
	var screensize = get_viewport_rect().size
	# move up and down based on input
	if Input.is_action_pressed(which+"_move_up") and position.y > 0:
		apply_impulse( Vector2(0,0),  Vector2( 0, -MOVE_SPEED * delta)) 
#		position.y = clamp(position.y, 0, screensize.y)
	if Input.is_action_pressed(which+"_move_down") and position.y < screensize.y:
		apply_impulse( Vector2(0,0),  Vector2( 0, MOVE_SPEED * delta)) 
#		position.y = clamp(position.y, 0, screensize.y)
	if Input.is_action_pressed(which+"_move_left") and position.x > 0:
		apply_impulse( Vector2(0,0),  Vector2( -MOVE_SPEED * delta, 0))
#		position.x = clamp(position.x, 0, screensize.x) 
	if Input.is_action_pressed(which+"_move_right") and position.x < screensize.x:
		apply_impulse( Vector2(0,0),  Vector2( MOVE_SPEED * delta, 0)) 
#		position.x = clamp(position.x, 0, screensize.x)
	