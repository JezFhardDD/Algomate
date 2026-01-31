extends Control

# Signal sent to the main script when the user lets go of a block
signal block_dropped(block: Control)

# List of preloaded textures
const TEXTURE_POOL = [
	preload("res://assets/BLOCK_ORANGE.png"),
	preload("res://assets/BLOCK_GREEN.png"),
	preload("res://assets/BLOCK_PURPLE.png"),
	preload("res://assets/BLOCK_RED.png")
]

@export var value: int = 0:
	set(v):
		value = v
		_update_text()

# Variables for dragging logic
var _dragging := false
var _drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO

func _ready() -> void:
	# Enable mouse input so the user can click and drag
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	set_random_texture()
	_update_text()

func _update_text() -> void:
	var label = get_node_or_null("NumberLabel")
	if label and label is Label:
		label.text = str(value)

func set_random_texture() -> void:
	var bg = get_node_or_null("Bg")
	if bg:
		if bg is TextureRect or bg is Sprite2D:
			bg.texture = TEXTURE_POOL.pick_random()

# --- DRAG AND DROP LOGIC (Required for Educational Interaction) ---
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# User clicked down
			_dragging = true
			_drag_offset = get_local_mouse_position()
			original_position = position
			move_to_front() # Bring block to top layer
		else:
			# User let go
			if _dragging:
				_dragging = false
				# Tell the main script we dropped the block so it can update the array
				emit_signal("block_dropped", self)

	elif event is InputEventMouseMotion and _dragging:
		# Move the block with the mouse
		var parent = get_parent()
		if parent:
			position = parent.get_local_mouse_position() - _drag_offset
