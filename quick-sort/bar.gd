extends Control

@onready var visual = $Visual
@onready var value_label = $Visual/ValueLabel

var value: int = 0

func setup(new_value: int, max_height: float):
	value = new_value
	value_label.text = str(value)
	
	# Set the height of the colored part relative to the value
	# We use custom_minimum_size to force the height
	visual.custom_minimum_size.y = new_value
	
	# Ensure the root control has width but lets the VBox manage height
	custom_minimum_size.x = 35 # Width of the bar

func set_color(color: Color):
	visual.color = color
