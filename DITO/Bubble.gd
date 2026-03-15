extends Control

signal block_dropped(block: Control)
signal block_pressed(block: Control) 

# List of preloaded textures
const TEXTURE_POOL = [
	preload("res://assets/BLOCK_ORANGE.png"),
	preload("res://assets/BLOCK_GREEN.png"),
	preload("res://assets/BLOCK_PURPLE.png"),
	preload("res://assets/BLOCK_RED.png")
]

@export var draggable := false
@export var value: int = 0:
	set(v):
		value = v
		_update_text()
var _wobble_tween: Tween = null
var _dragging := false
var _drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var target_position := Vector2.ZERO # For sorting animations

func _ready() -> void:
	set_random_texture()
	_update_text()
	# Always accept input so we can detect presses
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process_input(true)

func _update_text() -> void:
	var label = get_node_or_null("NumberLabel")
	if label and label is Label:
		label.text = str(value)

func hide_number(hide: bool):
	var label = get_node_or_null("NumberLabel")
	if label and label is Label:
		label.visible = not hide

func set_random_texture() -> void:
	var bg = get_node_or_null("Bg")
	if bg and bg is TextureRect:
		bg.texture = TEXTURE_POOL.pick_random()

# --- VISUAL HELPERS ---

func set_highlight(active: bool):
	# Makes the block glow when being compared
	if active:
		modulate = Color(1.5, 1.5, 1.5, 1.0) # Brighten
		scale = Vector2(1.1, 1.1)
		z_index = 10
	else:
		modulate = Color.WHITE
		scale = Vector2(1.0, 1.0)
		z_index = 0

func set_sorted_visual(is_sorted: bool = true):
	# Visual indication that this block is in its final sorted position
	if is_sorted:
		# Make it green and slightly larger/bolder
		modulate = Color(0.4, 1.0, 0.4, 1.0) # Brighter green
		# Add outline to the number label
		var label = get_node_or_null("NumberLabel")
		if label and label is Label:
			label.add_theme_color_override("font_color", Color(0, 0.5, 0, 1)) # Dark green text
			label.add_theme_constant_override("outline_size", 2)
			label.add_theme_color_override("font_outline_color", Color(1, 1, 1, 1)) # White outline
		# Slight scale increase for emphasis
		scale = Vector2(1.05, 1.05)
	else:
		modulate = Color.WHITE
		scale = Vector2(1.0, 1.0)
		var label = get_node_or_null("NumberLabel")
		if label and label is Label:
			label.add_theme_color_override("font_color", Color.WHITE)
			label.add_theme_constant_override("outline_size", 0)

func set_pivot_visual(is_pivot: bool):
	if is_pivot:
		# Purple tint with crown indicator (crown is handled by separate node)
		modulate = Color(0.9, 0.7, 1.0, 1.0) # Light purple
		var label = get_node_or_null("NumberLabel")
		if label and label is Label:
			label.add_theme_color_override("font_color", Color(0.5, 0, 0.8, 1)) # Purple text
			label.add_theme_constant_override("outline_size", 1)
			label.add_theme_color_override("font_outline_color", Color(1, 1, 1, 1))
	else:
		# Only reset if not sorted
		if modulate != Color(0.4, 1.0, 0.4, 1.0): # Don't override sorted visual
			modulate = Color.WHITE
			var label = get_node_or_null("NumberLabel")
			if label and label is Label:
				label.add_theme_color_override("font_color", Color.WHITE)
				label.add_theme_constant_override("outline_size", 0)

func set_outline_color(color: Color):
	var outline = get_node_or_null("Outline")
	if outline:
		outline.show()
		outline.modulate = color
		
func hide_outline():
	var outline = get_node_or_null("Outline")
	if outline:
		outline.hide()

# --- INPUT HANDLING (Single consolidated function) ---
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("block_pressed", self)
			if draggable:
				_dragging = true
				original_position = global_position
				_drag_offset = global_position - event.global_position
				z_index = 20
				_start_wobble()
		else:
			if _dragging:
				_dragging = false
				z_index = 0
				_stop_wobble()
				emit_signal("block_dropped", self)

	elif event is InputEventMouseMotion and _dragging:
		global_position = event.global_position + _drag_offset

func snap_back() -> void:
	_stop_wobble()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", original_position, 0.35)
	
func _start_wobble() -> void:
	if _wobble_tween:
		_wobble_tween.kill()
	_wobble_tween = create_tween().set_loops()
	_wobble_tween.tween_property(self, "rotation_degrees", -8.0, 0.15).set_trans(Tween.TRANS_SINE)
	_wobble_tween.tween_property(self, "rotation_degrees", 8.0, 0.15).set_trans(Tween.TRANS_SINE)
	_wobble_tween.tween_property(self, "rotation_degrees", 0.0, 0.1).set_trans(Tween.TRANS_SINE)

func _stop_wobble() -> void:
	if _wobble_tween:
		_wobble_tween.kill()
		_wobble_tween = null
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0.0, 0.1).set_trans(Tween.TRANS_SINE)
