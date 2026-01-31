extends Control

# Signal sent to the main script when the user lets go of a block
signal block_dropped(block)

# List of preloaded textures
# Make sure these paths match your file system exactly!
const TEXTURE_POOL = [
	preload("res://assets/BLOCK_ORANGE.png"),
	preload("res://assets/BLOCK_GREEN.png"),
	preload("res://assets/BLOCK_PURPLE.png"),
	preload("res://assets/BLOCK_RED.png")
]

# The number displayed on the block
@export var value: int = 0:
	set(new_value):
		value = new_value
		_update_text()

# Variables for dragging logic
var _dragging := false
var _drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO

func _ready() -> void:
	# Enable mouse input so the user can click and drag
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Set a random color and update the label immediately
	set_random_texture()
	_update_text()

func _update_text() -> void:
	# Finds the Label node named "NumberLabel" (or "Label" if you didn't rename it)
	var label = get_node_or_null("NumberLabel") 
	
	# Fallback if you named it just "Label"
	if label == null:
		label = get_node_or_null("Label")
		
	if label and label is Label:
		label.text = str(value)

func set_random_texture() -> void:
	# Finds the background texture (TextureRect or Sprite2D)
	var bg = get_node_or_null("Bg")
	
	# Fallback if you named it "TextureRect" or "Sprite"
	if bg == null:
		bg = get_node_or_null("TextureRect")
		
	if bg:
		if bg is TextureRect or bg is Sprite2D:
			bg.texture = TEXTURE_POOL.pick_random()

# --- DRAG AND DROP LOGIC ---
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# User clicked down: Start Dragging
			_dragging = true
			_drag_offset = get_local_mouse_position()
			original_position = position
			move_to_front() # Bring block to top layer so it doesn't get hidden
			
			# Optional: Scale up slightly to show it's being held
			scale = Vector2(1.1, 1.1)
			
		else:
			# User let go: Stop Dragging
			if _dragging:
				_dragging = false
				scale = Vector2(1.0, 1.0) # Reset scale
				
				# Emit signal so Main script knows to re-sort the array
				emit_signal("block_dropped", self)

	elif event is InputEventMouseMotion and _dragging:
		# Move the block with the mouse
		# We use the parent's coordinate space to position it correctly
		var parent = get_parent()
		if parent:
			position = parent.get_local_mouse_position() - _drag_offset
