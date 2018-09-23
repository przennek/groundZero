extends Node2D

# Display Fuel Percentage Text
export (bool) var display_fuel_text = true
onready var fuel_text = get_node("fuel_text")
onready var money_text = get_node("money_text")
var max_value = 1
var current_value = 1

var money = 0
onready var fuel_bar = get_node("fuel_progress")

# Start
func _ready():
	if(!display_fuel_text):
		fuel_text.hide()
		


func init(max_value, current_value):	
	self.max_value = max_value
	self.current_value = current_value
	fuel_bar.max_value = max_value
	fuel_bar.set_value(current_value)
	update()
	update_money()

func set_value(value):
	current_value = value
	update()

func substract_value(value):
	#current_value = current_value - value
	update()

func add_value(value):
	current_value = current_value + value
	update()
	
func substract_money(value):
	money = money - value
	update_money()

func add_money(value):
	money = money + value
	update_money()
	
func set_money(value):
	money = value
	update_money()

func update_money():
	var money_text = str(money) + "$"
	self.money_text.set_text(money_text.pad_decimals(0))

func update():
	var percentage = float(current_value) / max_value

	fuel_bar.set_value(current_value)
	
	var percentage_text = str(percentage * 1000)
	fuel_text.set_text(percentage_text.pad_decimals(0))