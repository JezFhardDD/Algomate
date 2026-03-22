extends ColorRect

var dragging := false
var last_position := Vector2.ZERO
var panning_enabled: bool = true

func set_panning_enabled(enabled: bool):
	panning_enabled = enabled
	
func _gui_input(event):
	if not panning_enabled:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_position = event.position

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_position
		position += delta
		last_position = event.position
		clamp_map()

func clamp_map():
	var parent_size = get_parent().size
	var map_size = size

	var min_x = parent_size.x - map_size.x
	var min_y = parent_size.y - map_size.y

	position.x = clamp(position.x, min_x, 0)
	position.y = clamp(position.y, min_y, 0)
