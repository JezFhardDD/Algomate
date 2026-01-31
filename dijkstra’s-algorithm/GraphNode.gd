extends Panel

# --- 1. SETUP ---
func _ready():
	# FORCE SMALLER SIZE (Optional, but good for safety)
	custom_minimum_size = Vector2(60, 60)
	size = Vector2(60, 60)
	
	# 1. CENTER TEXT
	var label = get_node_or_null("Label")
	if label:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.anchors_preset = Control.PRESET_FULL_RECT
		# Make sure text doesn't overflow
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		# Make font slightly smaller to fit
		label.add_theme_font_size_override("font_size", 12)
	
	# 2. MAKE CIRCULAR (Visual Setup)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.6, 0.2, 0.2) # Default Red/Brown
	# Set radius to half of size (30) to make it a perfect circle
	style.set_corner_radius_all(30) 
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color.WHITE
	
	add_theme_stylebox_override("panel", style)

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

# Called when distance updates (Relaxation)
func mark_processing():
	_change_color(Color(1, 0.65, 0)) # Orange

# Called when node is settled (Visited)
func mark_visited():
	_change_color(Color(0.2, 0.6, 0.2)) # Green

# Called when this is the final target
func mark_found():
	_change_color(Color(0.2, 0.2, 1.0)) # Blue

# Called on Reset
func reset_color():
	_change_color(Color(0.6, 0.2, 0.2)) # Original Red

# --- 4. HELPER FUNCTION ---
func _change_color(new_color: Color):
	var style = get_theme_stylebox("panel")
	if style is StyleBoxFlat:
		var new_style = style.duplicate()
		new_style.bg_color = new_color
		add_theme_stylebox_override("panel", new_style)
