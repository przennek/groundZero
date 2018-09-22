extends MarginContainer

var started = false;

func _ready():
	if globals.screen_type == globals.SCREEN_STATE.START:
		_swap_screen("start_screen.png");
	elif globals.screen_type == globals.SCREEN_STATE.WIN:
		_swap_screen("wygrana.png");
	elif globals.screen_type == globals.SCREEN_STATE.LOSE:
		_swap_screen("game_over.png");
	
func _input(event):	
	if event is InputEventKey and not started:
		if event.pressed and event.get_scancode() == 16777221:
			set_visible(false)
			started = true
			
func swap_screen_to_win():
	globals.screen_type = globals.SCREEN_STATE.WIN
	_swap_screen("wygrana.png");
	
func swap_screen_to_lose():
	globals.screen_type = globals.SCREEN_STATE.LOSE
	_swap_screen("game_over.png");
	
func swap_screen_to_start():
	globals.screen_type = globals.SCREEN_STATE.START
	_swap_screen("start_screen.png");

func _swap_screen(asset_path):
	var screen = ImageTexture.new(); 
	screen.load(asset_path);
	self.get_child(0).texture = screen;