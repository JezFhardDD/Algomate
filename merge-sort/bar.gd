extends Control

# Signal to tell Main that we dropped something on this bar
signal bar_dropped_on_me(dropped_index, my_index)

@onready var visual = $Visual
@onready var value_label = $Visual/ValueLabel

var value: int = 0
var index: int = 0 # We need to know our own index now

func setup(new_value: int, _max_height: float):
	value = new_value
	value_label.text = str(value)
	visual.custom_minimum_size = Vector2(70, 70)
	custom_minimum_size = Vector2(70, 70)

func set_index(new_index: int):
	index = new_index

func set_color(color: Color):
	visual.color = color

# --- DRAG AND DROP LOGIC ---

func _get_drag_data(at_position):
	# 1. Create a "Ghost" preview of the block
	var preview = ColorRect.new()
	preview.size = Vector2(50, 50)
	preview.color = visual.color
	preview.modulate.a = 0.5 # Semi-transparent
	
	# Center the preview on mouse
	var c = Control.new()
	c.add_child(preview)
	preview.position = -0.5 * preview.size
	set_drag_preview(c)
	
	# 2. Return data (My Index) so the receiver knows who was dragged
	return index

func _can_drop_data(at_position, data):
	# We only accept integers (indexes)
	return typeof(data) == TYPE_INT

func _drop_data(at_position, source_index):
	# When dropped, tell Main: "Source Index was dropped on Me (Target Index)"
	bar_dropped_on_me.emit(source_index, index)
