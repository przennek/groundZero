extends Node2D

# Display Fuel Percentage Text
export (bool) var display_fuel_text = true
onready var fuel_text = get_node("fuel_text")

# Health values
var max_value
var current_value

# Health


# Start
func _ready():
	if(!display_fuel_text):
		fuel_text.hide()

# Initializes the health bar
func init(max_value, current_value):
	self.max_value = max_value * 1.0
	self.current_value = clamp(current_value * 1.0, 0, max_value)
	
	# Update health bar
	update()


# Set current health value
func set_value(value):
	# Update value
	current_value = clamp(value, 0, max_value)
	
	# Update health bar
	update()

# Update Health Bar
func update():
	# Calc health percentage (0-1)
	var percentage = current_value / max_value
	
	# Update the health bar scale
	self.set_value(current_value)
	
	# Update the label
	var percentage_text = str(percentage * 100) + "%"
	fuel_text.set_text(percentage_text.pad_decimals(0))