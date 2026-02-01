extends Panel

# --- 1. SETUP ---
func _ready():
	# Ensure the label is centered text-wise and aligned within the panel
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

# Called when the algorithm puts the node in the Stack/Queue
func mark_processing():
	_change_color(Color(1, 0.65, 0)) # Orange/Yellow

# Called when the algorithm moves past this node
func mark_visited():
	_change_color(Color(0.3, 0.3, 0.3)) # Dark Gray

# Called when this node matches the Target Value
func mark_found():
	_change_color(Color(0, 0.8, 0)) # Bright Green

# Called when resetting the simulation
func reset_color():
	_change_color(Color(0.6, 0.2, 0.2)) # Original Red/Brown

# --- 4. HELPER FUNCTION ---
func _change_color(new_color: Color):
	# Duplicate stylebox to ensure unique color per node (Deep Copy)
	var style = get_theme_stylebox("panel")
	if style:
		var new_style = style.duplicate()
		new_style.bg_color = new_color
		add_theme_stylebox_override("panel", new_style)
