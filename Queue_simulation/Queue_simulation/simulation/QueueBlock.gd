extends Control

signal block_dropped(block: Control)

# List of preloaded textures from your assets folder
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

func _ready() -> void:
	# Randomize texture and update label when the block is created
	set_random_texture()
	_update_text()
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process_input(true)

func _update_text() -> void:
	var label = get_node_or_null("NumberLabel")
	if label and label is Label:
		label.text = str(value)
	else:
		print("⚠️ Missing NumberLabel!")

# This replaces your old set_color function
func set_random_texture() -> void:
	var bg = get_node_or_null("Bg")
	if bg and bg is TextureRect:
		bg.texture = TEXTURE_POOL.pick_random()
	elif bg and bg is Sprite2D:
		bg.texture = TEXTURE_POOL.pick_random()
	else:
		print("⚠️ Bg node is missing or not a TextureRect/Sprite2D!")

# 🖱️ Drag logic
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_drag_offset = get_local_mouse_position()
			original_position = position
			move_to_front() 
		else:
			if _dragging:
				_dragging = false
				emit_signal("block_dropped", self)

	elif event is InputEventMouseMotion and _dragging:
		var parent = get_parent()
		var global_mouse = get_global_mouse_position()

		var new_pos: Vector2
		if parent and parent is Control:
			new_pos = parent.get_local_mouse_position() - _drag_offset
		else:
			new_pos = global_mouse - _drag_offset

		position = new_pos
