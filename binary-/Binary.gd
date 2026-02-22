extends Control

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

var _dragging := false
var _drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var target_position := Vector2.ZERO # For sorting animations

func _ready() -> void:
	set_random_texture()
	_update_text()
	mouse_filter = Control.MOUSE_FILTER_IGNORE # Disable drag for sorting sim usually
	set_process_input(false) 

func _update_text() -> void:
	var label = get_node_or_null("NumberLabel")
	if label and label is Label:
		label.text = str(value)

func set_random_texture() -> void:
	var bg = get_node_or_null("Bg")
	if bg and bg is TextureRect:
		bg.texture = TEXTURE_POOL.pick_random()

# --- NEW VISUAL HELPERS FOR BUBBLE SORT ---

func set_highlight(active: bool):
	# Makes the block glow when being compared
	var _bg = get_node_or_null("Bg")
	if active:
		modulate = Color(1.5, 1.5, 1.5, 1.0) # Brighten
		scale = Vector2(1.1, 1.1)
		z_index = 10
	else:
		modulate = Color.WHITE
		scale = Vector2(1.0, 1.0)
		z_index = 0

func set_sorted_visual():
	# Visual indication that this block is in its final sorted position
	modulate = Color(0.6, 1.0, 0.6, 1.0) # Greenish tint
