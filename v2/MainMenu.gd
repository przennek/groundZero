extends MarginContainer

var started = false;

func _ready():
	pass
	
func _input(event):
	if event is InputEventKey and not started:
		if event.pressed:
			set_visible(false)
			started = true