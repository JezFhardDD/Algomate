extends Camera2D

var dragging := false
var last_position := Vector2.ZERO

func _input(event):

	# --- Mouse ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_position = event.position

	elif event is InputEventMouseMotion and dragging:
		var delta = last_position - event.position
		position += delta
		last_position = event.position

	# --- Touch ---
	elif event is InputEventScreenTouch:
		dragging = event.pressed
		last_position = event.position

	elif event is InputEventScreenDrag and dragging:
		var delta = last_position - event.position
		position += delta
		last_position = event.position
