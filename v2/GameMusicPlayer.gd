extends AudioStreamPlayer

var start_music = load("res://music/start.ogg")
var game_over_music = load("res://music/game_over.ogg")
var win_music = load("res://music/win.ogg")

func _ready():
	pass

func play_start_music():
	self.stream = start_music
	self.play()
	
func play_game_over_music():
	self.stream = game_over_music
	self.play()
	
func play_win_music():
	self.stream = win_music
	self.play()