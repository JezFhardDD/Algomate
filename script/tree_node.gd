extends Panel

# --- 1. SETUP ---
func _ready():
	# 1. Make the square background invisible
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0) # Transparent
	add_theme_stylebox_override("panel", style)
	
	# 2. Center the label text
	var label = get_node_or_null("Label")
	if label:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.anchors_preset = Control.PRESET_FULL_RECT

# --- 2. DATA HANDLING ---
func set_value(new_value):
	var label = get_node_or_null("Label")
	if label:
		label.text = str(new_value)

func get_value():
	var label = get_node_or_null("Label")
	if label:
		return int(label.text)
	return -1

# --- 3. VISUAL STATES ---

func mark_processing():
	_change_color(Color(1, 0.65, 0)) # Orange

func mark_visited():
	_change_color(Color(0.3, 0.3, 0.3)) # Dark Gray

func mark_found():
	_change_color(Color(0, 0.8, 0)) # Green

func reset_color():
	_change_color(Color(1, 1, 1)) # White (Original)

# --- 4. HELPER FUNCTION ---
func _change_color(new_color: Color):
	# Color the Sprite2D instead of the Panel
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		var tw = create_tween()
		tw.tween_property(sprite, "modulate", new_color, 0.2)
