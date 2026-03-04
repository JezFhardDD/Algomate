extends Control

signal block_dropped(block: Control)

const TEXTURE_POOL = [
	preload("res://assets/BLOCK_ORANGE.png"), # Index 0: Base
	preload("res://assets/BLOCK_GREEN.png"),
	preload("res://assets/BLOCK_PURPLE.png"),
	preload("res://assets/BLOCK_RED.png")
]

@export var value: int = 0:
	set(v):
		value = v
		_update_text()

# Store unique color here
var base_color: Color = Color.WHITE

var _dragging := false
var _drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	var bg = get_node_or_null("Bg")
	if bg and (bg is TextureRect or bg is Sprite2D):
		# This will grab a random texture from your TEXTURE_POOL array
		bg.texture = TEXTURE_POOL.pick_random() 
	
	_update_text()

func _update_text() -> void:
	var label = get_node_or_null("NumberLabel")
	if label and label is Label:
		label.text = str(value)

func set_base_color(col: Color) -> void:
	pass

func reset_color() -> void:
	modulate = base_color

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_drag_offset = get_local_mouse_position()
			original_position = position
			move_to_front()
			modulate = Color(0.2, 1, 0.2) 
		else:
			if _dragging:
				_dragging = false
				emit_signal("block_dropped", self)

	elif event is InputEventMouseMotion and _dragging:
		var parent = get_parent()
		if parent:
			position = parent.get_local_mouse_position() - _drag_offset
