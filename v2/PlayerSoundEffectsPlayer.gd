extends AudioStreamPlayer

var drill_sound_effect = load("res://music/drill_sound_effect.ogg")

func _ready():
	drill_sound_effect.set_loop(false)
	pass
	
func play_drill_sound_effect():
	self.stream = drill_sound_effect
	self.play()
